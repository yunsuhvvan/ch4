<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false"%>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'Logout'}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>yunsuhwan</title>
    <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/index.css'/>">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
    <style>
        .clearfix:before,
        .clearfix:after {
            display: table;

            content: ' ';
        }
        .clearfix:after {
            clear: both;
        }
        body {
            background: #f0f0f0 !important;
        }
        .page-404 .outer {
            position: absolute;
            top: 0;

            display: table;

            width: 100%;
            height: 100%;
        }
        .page-404 .outer .middle {
            display: table-cell;

            vertical-align: middle;
        }
        .page-404 .outer .middle .inner {
            width: 300px;
            margin-right: auto;
            margin-left: auto;
        }
        .page-404 .outer .middle .inner .inner-circle {
            height: 300px;

            border-radius: 50%;
            background-color: #ffffff;
        }
        .page-404 .outer .middle .inner .inner-circle:hover i {
            color: #39bbdb!important;
            background-color: #f5f5f5;
            box-shadow: 0 0 0 15px #39bbdb;
        }
        .page-404 .outer .middle .inner .inner-circle:hover span {
            color: #39bbdb;
        }
        .page-404 .outer .middle .inner .inner-circle i {
            font-size: 5em;
            line-height: 1em;

            float: right;

            width: 1.6em;
            height: 1.6em;
            margin-top: -.7em;
            margin-right: -.5em;
            padding: 20px;

            -webkit-transition: all .4s;
            transition: all .4s;
            text-align: center;

            color: #f5f5f5!important;
            border-radius: 50%;
            background-color: #39bbdb;
            box-shadow: 0 0 0 15px #f0f0f0;
        }
        .page-404 .outer .middle .inner .inner-circle span {
            font-size: 11em;
            font-weight: 700;
            line-height: 1.2em;

            display: block;

            -webkit-transition: all .4s;
            transition: all .4s;
            text-align: center;

            color: #e0e0e0;
        }
        .page-404 .outer .middle .inner .inner-status {
            font-size: 20px;

            display: block;

            margin-top: 20px;
            margin-bottom: 5px;

            text-align: center;

            color: #39bbdb;
        }
        .page-404 .outer .middle .inner .inner-detail {
            line-height: 1.4em;

            display: block;

            margin-bottom: 10px;

            text-align: center;

            color: #999999;
        }

    </style>
</head>

<body>


<div class="page-404">
    <div class="outer">
        <div class="middle">
            <div class="inner">
                <!--BEGIN CONTENT-->
                <div class="inner-circle"><i class="fa fa-cogs"></i><span>404</span></div>
                <span class="inner-status">Opps! The page not found</span>
                <span class="inner-detail">Unfortunately we're sorry for that the page what you are looking for please wait for a while</span>
                <!--END CONTENT-->
                <div style="text-align: center"><a href="<c:url value='/'/>">Back to Main Page Again.</a></div>

            </div>
        </div>
    </div>
</div>

</body>
</html>