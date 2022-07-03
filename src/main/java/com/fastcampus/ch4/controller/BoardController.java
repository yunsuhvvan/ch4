package com.fastcampus.ch4.controller;

import com.fastcampus.ch4.domain.*;
import com.fastcampus.ch4.service.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.*;

import javax.servlet.http.*;
import java.time.*;
import java.util.*;

@Controller
@RequestMapping("/board")
public class BoardController {
    @Autowired
    BoardService boardService;


    // **수정하기;**
    @PostMapping("/modify")
    public String modify(BoardDto boardDto, HttpSession session, Model m , RedirectAttributes rattr, Integer page , Integer pageSize, SearchCondition sc) {
        String writer = (String) session.getAttribute("id");
        boardDto.setWriter(writer);

        System.out.println("sc.getQueryString() = " + sc.getQueryString());
        try {
            // 흠 왜 이거 안되지
            m.addAttribute("page", sc.getPage());
            m.addAttribute("pageSize", sc.getPageSize());

            int rowCnt =  boardService.modify(boardDto); // insert

            if (rowCnt != 1) {
                throw new  Exception("modify Failed");
            }
            rattr.addFlashAttribute("msg", "MOD_OK");
            return "redirect:/board/list"+sc.getQueryString();
        } catch (Exception e) {
            e.printStackTrace();
            // 실패하면 사용자가 그전에 입력했던 내용을 보여주기 위해서 Model에 담기
            m.addAttribute("boardDto", boardDto);
            m.addAttribute("msg", "MOD_ERR");
            return "board";
        }
    }


    // **작성하기**
    @PostMapping("/write")
    public String write(BoardDto boardDto, HttpSession session, Model m , RedirectAttributes rattr) {
        String writer = (String) session.getAttribute("id");
        boardDto.setWriter(writer);
        try {
           int rowCnt =  boardService.write(boardDto); // insert

            if (rowCnt != 1) {
                throw new  Exception("Write Failed");
            }
            rattr.addFlashAttribute("msg", "WRT_OK");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            // 실패하면 사용자가 그전에 입력했던 내용을 보여주기 위해서 Model에 담기
            m.addAttribute("boardDto", boardDto);
           m.addAttribute("msg", "WRT_ERR");
            return "board";
        }
    }


    //**단순 페이지 이동**
    @GetMapping("/write")
    public String writer(Model m) {
        m.addAttribute("mode", "new");
        return "board"; // 일기와 쓰기에 사용, 쓰기에 사용할때는 mode=new
    }

    // **삭제하기**
    @PostMapping("/remove")
    public String remove(Integer bno, Integer page, Integer pageSize , Model m , HttpSession session , RedirectAttributes rattr) {
        String writer = (String) session.getAttribute("id");
        try {
            //Model에 담아서 아래 jsp로 보냄,  리다이렉트 할때 뒤에 자동으로 붙음
            m.addAttribute("page", page);
            m.addAttribute("pageSize", pageSize);

            int rowCnt = boardService.remove(bno, writer);
            // 삭제가 되면 boardList.jsp로 msg = "DEL_OK" 를 보냄

            if(rowCnt == 1){
                // m.addAttribute와 달리 일회성이기때문에 URL에 계속 보이지 않는다.  Session에 잠깐 쓰고 저장하기떄문에 부담 적음
               rattr.addFlashAttribute("msg" , "DEL_OK");
                return "redirect:/board/list";
            }

            if (rowCnt != 1) {
                throw new Exception("board remove error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // rowCnt != 1(에러가 발생한다면..)
            // m.addAttribute와 달리 일회성이기때문에 URL에 계속 보이지 않는다.  Session에 잠깐 쓰고 저장하기떄문에 부담 적음
            rattr.addFlashAttribute("msg", "DEL_ERR");
        }
        return "redirect:/board/list";
    }


    // **게시물 읽기**
    @GetMapping("/read")
    public String read(Integer bno, Model m , Integer page , Integer pageSize) {
        try {
            BoardDto boardDto = boardService.read(bno);
//            m.addAttribute("boardDto", boardDto);// 아래 문장과 동일
            m.addAttribute(boardDto);
            m.addAttribute("page", page);
            m.addAttribute("pageSize", pageSize);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "board";
    }

    @GetMapping("/list")
    public String list(Model m, SearchCondition sc, HttpServletRequest request) {
        if(!loginCheck(request))
            return "redirect:/login/login?toURL="+request.getRequestURL();  // 로그인을 안했으면 로그인 화면으로 이동

        try {
            int totalCnt = boardService.getSearchResultCnt(sc);
            m.addAttribute("totalCnt", totalCnt);

            PageHandler pageHandler = new PageHandler(totalCnt, sc);

            List<BoardDto> list = boardService.getSearchResultPage(sc);
            m.addAttribute("list", list);
            m.addAttribute("ph", pageHandler);

            Instant startOfToday = LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant();
            m.addAttribute("startOfToday", startOfToday.toEpochMilli());
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute("msg", "LIST_ERR");
            m.addAttribute("totalCnt", 0);
        }
        return "boardList"; // 로그인을 한 상태이면, 게시판 화면으로 이동
    }
    private boolean loginCheck(HttpServletRequest request) {
        // 1. 세션을 얻어서
        HttpSession session = request.getSession();
        // 2. 세션에 id가 있는지 확인, 있으면 true를 반환
        return session.getAttribute("id")!=null;
    }
}