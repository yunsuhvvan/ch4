package com.fastcampus.ch4.controller;

import com.fastcampus.ch4.domain.CommentDto;
import com.fastcampus.ch4.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
public class CommentController {

    @Autowired
    CommentService service;

    // 지정된 댓글을 수정하는 메서드
    @PatchMapping("/comments/{cno}")  // /comments/1?bno=231    <-- 수정할 댓글 번호
    public ResponseEntity<String> modify(@PathVariable Integer cno, @RequestBody CommentDto dto, HttpSession session) {
        String commenter = (String) session.getAttribute("id");

        //String commenter = session.getId();

        dto.setCommenter(commenter);
       dto.setCno(cno);
        try {
            if (service.modify(dto) != 1) {
                throw new Exception("modify failed");
            }
            return new ResponseEntity<>("MOD_OK", HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<String>("MOD_ERR", HttpStatus.BAD_REQUEST);
        }

    }



    // 댓글을 등록하는 메서드
    @PostMapping("/comments") //  /ch4/comments?bno=1085 POST
    public ResponseEntity<String> write(@RequestBody CommentDto dto ,  Integer bno , HttpSession session) {
        String commenter = (String) session.getAttribute("id");

        dto.setCommenter(commenter);
        dto.setBno(bno);

        try {
            if (service.write(dto) != 1) {
                throw new Exception("Write failed");
            }
            return new ResponseEntity<>("WRT_OK", HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<String>("WRT_ERR", HttpStatus.BAD_REQUEST);
        }
    }

    // 지정된 댓글을 삭제하는 메서드
    @DeleteMapping("/comments/{cno}")  // /comments/1?bno=231    <-- 삭제할 댓글 번호
    public ResponseEntity<String> remove(@PathVariable Integer cno, Integer bno , HttpSession session) {
//        String commenter = (String) session.getAttribute("id");
        String commenter = (String) session.getAttribute("id");
        try {
            int rowCnt = service.remove(cno, bno, commenter);
            if (rowCnt != 1) {
                throw new Exception("Delete Failed");
            }
            return new ResponseEntity<>("DEL_OK", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("DEL_ERR", HttpStatus.BAD_REQUEST);
        }

    }


    // 지정된 게시물의 모든 댓글을 가져오는 메서드
    @GetMapping("/comments")
    public  ResponseEntity<List<CommentDto>>list(Integer bno) {
        List<CommentDto> list = null;
        try {
            list = service.getList(bno);
            // 에러가 나든 성공하든 항상 200번 이기때문에 성공했을떄와 실패했을때 다른 상태코드를 줄 수 있어야한다.
            return new ResponseEntity<List<CommentDto>>(list , HttpStatus.OK); // 200
        } catch (Exception e) {
            e.printStackTrace();
            // 에러가 나든 성공하든 항상 200번 이기때문에 성공했을떄와 실패했을때 다른 상태코드를 줄 수 있어야한다.
            return new ResponseEntity<List<CommentDto>>(HttpStatus.BAD_REQUEST);// 400
        }
    }
}
