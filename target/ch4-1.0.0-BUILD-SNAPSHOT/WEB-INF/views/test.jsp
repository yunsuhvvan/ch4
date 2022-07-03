
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>  <!--core_rt 버전 불일치때문에  _rt 를 붙힘 가끔식 jstl에서 에러가 많이 난다.-->
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'Logout'}"/>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<c:url value='/css/modal.css'/>">
    <link rel="stylesheet" href="<c:url value='/js/modal.js'/>">
    <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <title>Title</title>
    <style>
        * {
            box-sizing: border-box;
        }
        input[type=text], select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            resize: vertical;
        }
        label {
            padding: 12px 12px 12px 0;
            display: inline-block;
        }
        input[type=submit] {
            background-color: #04AA6D;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            float: right;
        }
        input[type=submit]:hover {
            background-color: #45a049;
        }
        .container {
            border-radius: 5px;
            background-color: #f2f2f2;
            padding: 20px;
        }
        .col-25 {
            float: left;
            width: 25%;
            margin-top: 6px;
        }
        .col-75 {
            float: left;
            width: 75%;
            margin-top: 6px;
        }
        /* Clear floats after the columns */
        .row:after {
            content: "";
            display: table;
            clear: both;
        }
        /* Responsive layout - when the screen is less than 600px wide, make the two columns stack on top of each other instead of next to each other */
        @media screen and (max-width: 600px) {
            .col-25, .col-75, input[type=submit] {
                width: 100%;
                margin-top: 0;
            }
        }

        #commentList{
            margin-top: 50px;
            margin-left: 370px;
            width: 700px;
        }
        .commentBox{
            border: 1px solid lightgray;
            border-radius: 13px;
            display: block;
            width: 100%;
            height: 100px;
            background-color: #f9f9fa;
            padding-bottom: 20px;
            color: black;
            margin-bottom: 15px;
            margin-top: 5px;

        }
        #replyForm{
            position: absolute;
        }


    </style>

</head>
<body>
<button id="myBtn" class="btn" style="display: block; margin: 20px auto;"><i class="fa fa-pencil"></i> 댓글 달기</button>
<div id="commentList"></div>

<div id="replyForm" style="display: none">
    <input type="text" name="replyComment">
    <input type="hidden" name="commenter" id="commenter" value="${loginId}">
    <button id="wrtRepBtn" class="btn"><i class="fa fa-pencil"></i> 등록</button>
</div>


<!-- The Modal -->
<div id="myModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
        <span class="close">&times;</span>
        <div class="container">
            <div class="row">
                <div class="col-25">
                    <label for="writer">작성자</label>
                </div>
                <div class="col-75">
                    <input type="text" id="writer" name="commenter" value="${loginId}">
                </div>
            </div>

            <div class="row">
                <div class="col-25">
                    <label for="comment">댓글</label>
                </div>
                <div class="col-75">
                    <textarea id="comment" name="comment" placeholder="댓글을 입력해주세요.." style="height:100px"></textarea>
                </div>
            </div>
            <div class="row">
                <button id="sendBtn" type="button" class="btn"><i class="fa fa-pencil"></i>SEND</button>
                <button id="modBtn" type="button" class="btn"><i class="fa fa-edit"></i> 수정</button>
            </div>
        </div>
    </div>

</div>

<script>
    // 댓글 가져오기
    let showList = function (bno) {
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/ch4/comments?bno='+bno,  // 요청 URI
            success : function(result){
                $("#commentList").html(toHtml(result));
                if ("${loginId}" !== result.commenter){
                    // $('.commentBox').data("cno").children('button').css("display", "none");
                    // $('.commentBox').children('button').css("display", "none");
                    var cno = $('.commentBox').data("cno");


                }
            },
            error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    };

    $(document).ready(function(){
     let bno = ${boardDto.bno};
        showList(bno);
        // 댓글 입력
        $("#sendBtn").click(function(){
            let comment = $("textarea[name=comment]").val();
            if(comment.trim() == ''){
                alert("댓글을 입력해주세요");
                $("input[name=comment]").focus();
                return;
            }
            $.ajax({
                type : 'POST',      //  요청 메서드
                url : '/ch4/comments?bno='+bno,  //  요청 URI
                headers : {"content-type" : "application/json"}, //요청헤더
                data : JSON.stringify({
                    bno :bno ,
                    comment: comment
                }),
                success: function (result) {
                    alert(result);
                    showList(bno);
                    $('#comment').val('');
                    $('#myModal').hide();
                },
                error : function (){
                    alert("error");
                }
            })
        });

        $("#commentList").on("click", ".modBtn", function () {
            let cno = $(this).parent().attr("data-cno");
            let comment = $("span.comment", $(this).parent()).text();
            //  1. comment의 내용을 input에 뿌려주기
            $("textarea[name=comment]").val(comment);
            //  2. cno전달하기
            $("#modBtn").attr("data-cno", cno);
            if ($('#comment').val() != null){
                $('#sendBtn').css("display", "none");
            }
            $('#myModal').show();
        });
        // 댓글 수정
        $("#modBtn").click(function(){
            let cno = $(this).attr("data-cno");
            let comment = $("textarea[name=comment]").val();
            if(comment.trim() == ''){
                alert("댓글을 입력해주세요");
                $("input[name=comment]").focus();
                return;
            }
            $.ajax({
                type : 'PATCH',      //  요청 메서드
                url : '/ch4/comments/'+cno,  //  요청 URI
                headers : {"content-type" : "application/json"}, //요청헤더
                data : JSON.stringify({
                    cno :cno ,
                    comment: comment
                }),
                success: function (result) {
                    alert(result);
                    showList(bno);
                    $('#myModal').hide();
                },
                error : function (){
                    alert("error");
                }
            })
        });
            // 댓글 삭제
            //$(".delBtn").click(function(){
            $("#commentList").on("click", ".delBtn", function () {
                let cno = $(this).parent().attr("data-cno");
                let bno = $(this).parent().attr("data-bno");
                $.ajax({
                    type: 'DELETE',       // 요청 메서드
                    url: '/ch4/comments/' + cno + '?bno=' + bno,  // 요청 URI
                    success: function (result) {
                        alert(result);
                        showList(bno);
                    },
                    error: function () {
                        alert("error")
                    } // 에러가 발생했을 때, 호출될 함수
                }); // $.ajax()
            });

        $("#commentList").on("click", ".replyBtn", function () {
            //  1.replyForm을 옮기고
            $("#replyForm").appendTo($(this).parent());
            //  2. 답글을 입력할 폼을 보여주고
            $("#replyForm").css("display", "block");
        });
        // 대댓글 작성하기
        $("#wrtRepBtn").click(function(){
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyForm").parent().attr("data-pcno");//  답글을 달기위해서 답글의 본래 댓글이 필요.
            let commenter = $('#commenter').val();


            if(comment.trim() == ''){
                alert("댓글을 입력해주세요");
                $("input[name=replyComment]").focus();
                return;
            }
            $.ajax({
                type : 'POST',      //  요청 메서드
                url : '/ch4/comments?bno='+bno,  //  요청 URI
                headers : {"content-type" : "application/json"}, //요청헤더
                data : JSON.stringify({
                    bno :bno ,
                    comment: comment,
                    pcno : pcno,
                    commenter : commenter
                }),
                success: function (result) {
                    alert(result);
                    showList(bno);
                },
                error : function (){
                    alert("error");
                }
            })
        });
        $("#replyForm").css("display", "none");
        $("input[name=replyComment]").val('');
        $("#replyForm").appendTo("body");

        // 모달

        // Get the modal
        var modal = document.getElementById("myModal");

        // Get the button that opens the modal
        var btn = document.getElementById("myBtn");

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks the button, open the modal
        btn.onclick = function() {
            modal.style.display = "block";
        }

        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }



    });


    //날짜


    let toHtml = function (comments) {
        let tmp = "<ul style='display: block'>";
        comments.forEach(function (comment) {

            const date = new Date(comment.up_date);

            tmp += ' <li class="commentBox" data-cno='+ comment.cno
            tmp += ' data-pcno=' + comment.pcno
            tmp+= ' data-bno=' +comment.bno + '>'
            if(comment.cno!=comment.pcno){
                tmp += '<span><i class="fa-solid fa-turn-down-right"></i>↪️</span>'
            }
            tmp += '<span class="commenter">writer : ' + comment.commenter +'</span><br>&nbsp;'
            tmp += 'content : <span class="comment">' + comment.comment +'</span><br>&nbsp;'
            tmp +=  'date : ' +date.getFullYear() + '년'
                              +(date.getMonth()+1) +'월'
                              + date.getUTCDate() +'일'
                              + date.getHours() + '시'
                              + date.getMinutes() + '분'
            if (comment.commenter == "${loginId}" ){
                tmp += '<button class="btn delBtn" style="margin-left: 2px"><i class="fa fa-trash"></i> 삭제</button>'
                tmp += '<button class="btn modBtn" style="margin-left: 2px"><i class="fa fa-edit"></i> 수정</button>'
            }
            tmp += '<button class="btn replyBtn" style="margin-left: 2px"><i class="fa fa-pencil"></i> 답글</button>'
            tmp += '</li>'
        });
        return tmp + "</ul>";
    };



</script>
</body>
</html>