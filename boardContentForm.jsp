<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/views/common2.jsp"%>

<c:if test="${empty boardDTO}">
	<script>
		alert("게시판 글이 삭제 되었습니다.")
		location.replace("/erp/boardList.do");
	</script>
</c:if>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판</title>
	<script>
		//-----------------------------------------------------------------------
		// 게시판 입력 화면으로 이동하는 함수 선언
		//-----------------------------------------------------------------------
		function goBoardRegForm(){
			//document.boardContentForm.action = "/erp/boardRegForm.do";
			document.boardContentForm.submit();
		}
		//-----------------------------------------------------------------------
		// 게시판 수정 화면으로 이동하는 함수 선언
		//-----------------------------------------------------------------------
		function goBoardUpDelForm(){
			document.boardContentForm.action = "/erp/boardUpDelForm.do";
			document.boardContentForm.submit();
		}
	</script>
</head>
<body><center><br>
<!----------------------------------------------------------------------->
<!-- [1개의 게시판 내용] 출력하고 게시판 등록 화면으로 이동하는 form 태그 선언 -->
<!----------------------------------------------------------------------->
<form class="boardContentForm" name="boardContentForm" method="post" action="/erp/boardRegForm.do">
	<b>[글 상세보기]</b>
	<table class="tbcss1" width="500" border="1" bordercolor="#DDDDDD" cellpadding="5" align="center">
		<tr align="center">
			<th bgcolor="#C6C6C6" width=60>글번호
			<td width=150>${boardDTO.b_no}
			<th bgcolor="#C6C6C6" width=60>조회수
			<td width=150>${boardDTO.readcount}
		<tr align="center">
			<th bgcolor="#C6C6C6">작성자
			<td>${boardDTO.writer}
			<th bgcolor="#C6C6C6">작성일
			<td>${boardDTO.reg_date}
		<tr>
			<th bgcolor="#C6C6C6">글제목
			<td colspan="3">${boardDTO.subject}
		<tr>
			<th bgcolor="#C6C6C6">글내용
			<td colspan="3"><pre>${boardDTO.content}</pre>
	</table>
	<table><tr height=3><td></table>
	<!-- hidden의 데이터를 보고싶으면 text로 바꿔서 보자 -->
	<input type="hidden" name="b_no" value="${boardDTO.b_no}">
	<input type="button" value="글 수정/삭제" onclick="goBoardUpDelForm()">&nbsp;
	<input type="button" value="댓 글쓰기" onclick="goBoardRegForm()">&nbsp;
	<input type="button" value="글 목록보기" onclick="location.replace('/erp/boardList.do');">
	
</form>

</body>
</html>