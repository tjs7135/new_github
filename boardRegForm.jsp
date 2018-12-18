<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/erp/resources/jquery-1.11.0.min.js"></script>
<link href="/erp/resources/style1.css" rel="stylesheet" type="text/css">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판</title>

<script>
	/*
	//-----------------------------------------------------------------------
	// body 태그 안의 태그를 모두 실행한 후에 실행할 자스 코드 설정
	// ah haki ssilhaㅓ
	//-----------------------------------------------------------------------
	$(documnet).ready(function(){
		<c:if test="${!empty param.b_no}">
			$("[name=b_no]").val("${param.b_no}")
		</c:if>
	})*/
	//-----------------------------------------------------------------------
	// [게시판 새글쓰기 화면]에 입력된 데이터의 유효성 체크 함수 선언
	//-----------------------------------------------------------------------
	function checkBoardRegForm(){
		// 입력된 작성자명 가져와서 변수에 저장
		var writer = $("[name=writer]").val();
		// 작성자명이 입력되지 않았으면 경고하고 함수 중단
		if( writer.split(" ").join("")==""){
			alert( "이름을 입력해 주십시요" );
			$("[name=writer]").focus();
			return;
		}
			// 입력된 [제목]을 가져와서 변수에 저장
			var subject = $("[name=subject]").val();
			// [제목]이 입력되지 않았으면 경고하고 함수 중단
			if( subject.split(" ").join("")==""){
				alert( "제목을 입력해 주십시요" );
				$("[name=subject]").focus();
				return;
			}
			// 입력된 [이메일]을 가져와서 변수에 저장
			var email = $("[name=email]").val();
			// [이메일]이 입력되지 않았으면 경고하고 함수 중단
			if( email.split(" ").join("")==""){
				alert( "이메일을 입력해 주십시요" );
				$("[name=email]").focus();
				return;
			}
			// 입력된 [게시판 글]을 가져와서 변수에 저장
			var content = $("[name=content]").val();
			// [게시판 글]이 입력되지 않았으면 경고하고 함수 중단
			if( content.split(" ").join("")==""){
				alert( "내용을 입력해 주십시요" );
				$("[name=content]").focus();
				return;
			}
			// 입력된 [암호]를 가져와서 변수에 저장
			var pwd = $("[name=pwd]").val();
			// [암호]가 입력되지 않았으면 경고하고 함수 중단
			if( pwd.split(" ").join("")==""){
				alert( "암호를 입력해 주십시요" );
				$("[name=pwd]").focus();
				return;
			}
			if( confirm("정말 저장하시겠습니까?")==false ){ return; }
			//-----------------------------------------------------------------------
			// 현재 화면에서 페이지 이동 없이(=비동기 방식으로)
			// 서버쪽으로 "/erp/boardRegProc.do" 을 호출하여
			// 게시판글 입력 후 취할 행동이 있는 html 소스를 문자열로 받기
			//-----------------------------------------------------------------------
			$.ajax({
				// 서버쪽 호출 URL 주소 지정
				url : "/erp/boardRegProc.do"
				// 전송 방법 설정
				, type : "post"
				, dataType : "json"
				//서버에 보낼 파라미터명과 파라미터값을 설정
				, data : $("[name=boardRegForm]").serialize()
				// 서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정
				// 익명함수의 매개변수 html 에는 boardRegProc.jsp 의 실행 결과물인 html 소스가 문자열로 들어옴.
				, success : function( insertCnt ){
					if( insertCnt>0 ){
						alert("게시판 새글쓰기 입력 성공")
						location.replace("/erp/boardList.do");
					}else{
						alert("게시판 새글쓰기 입력 실패");
					}
				}
				// 서버의 응답을 못 받았을 경우 실행할 익명함수 설정
				, error : function(){
					alert("서버 접속 실패!");
				}
			});
		}
</script>

</head>
<body><br><center>
<form method="post" name="boardRegForm" action="/erp/boardRegProc.do" >

	<c:if test="${empty param.b_no}">
		<b>[새 글쓰기]</b>
	</c:if>
	<c:if test="${!empty param.b_no}">
		<b>[댓 글쓰기]</b>
	</c:if>
	<table class="tbcss1" border="1" bordercolor=gray cellspacing="0" cellpadding="5" align="center">
		<tr>
			<th bgcolor=#C6C6C6>이 름
			<td><input type="text" size="10" maxlength="10" name="writer"></td>
		</tr>
		<tr>
			<th bgcolor=#C6C6C6>제 목
			<td><input type="text" size="40" maxlength="50" name="subject"></td>
		</tr>
		<tr>
			<th bgcolor=#C6C6C6>이메일
			<td><input type="text" size="40" maxlength="30" name="email"></td>
		</tr>
		<tr>
			<th bgcolor=#C6C6C6>내 용
			<td><textarea name="content" rows="13" cols="40"></textarea></td>
		</tr>
		<tr>
			<th bgcolor=#C6C6C6>비밀번호
			<td><input type="password" size="8" maxlength="12" name="pwd"></td>
		</tr>
	</table>
	<table><tr height=4><td></table>
	
	<input type="hidden" name="b_no" value="${param.b_no}">
	<input type="button" value="저장" onClick="checkBoardRegForm()">
	<input type="reset" value="다시작성">
	<input type="button" value="목록보기" onclick="location.replace('/erp/boardList.do')">
</form>

</body>
</html>