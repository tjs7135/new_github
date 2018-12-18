<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/views/common2.jsp"%>
  
<!----------------------------------------------------------------------->
<!-- 로그인 상태가 아니면 경고하고 로그인 화면으로 이동하기 -->
<!----------------------------------------------------------------------->
<!--
<c:if test="${empty sessionScope.admin_id}">
	<script>
		alert("로그인 상태가 아닙니다.. 로그인 바람");
		location.replace("/erp/loginForm.do")
	</script>
</c:if>
-->
<html>
<head>
	<title>게시판 목록</title>
	<script>
		//-----------------------------------------------------------------------
		// body 태그 안의 태그를 모두 실행한 후에 실행할 자스 코드 설정
		//-----------------------------------------------------------------------
		$(document).ready(function(){
			//-----------------------------------------------------------------------
			// 이전 화면에서 입력. 선택한 데이터를 재 입력하여 흔적 남기기
			//-----------------------------------------------------------------------
			$("[name=selectPageNo]").val( "${requestScope.selectPageNo}" );
			$("[name=rowCntPerPage]").val( "${empty param.rowCntPerPage?10:param.rowCntPerPage}" );
			$("[name=keyword]").val( "${param.keyword}" );
			
			<c:if test="${!empty param.keywordTarget}">
				$("[name=keywordTarget]").val( "${param.keywordTarget}" );
			</c:if>
			//-----------------------------------------------------------------------
			// 한 페이지에서 보여줄 게시판 목록 행의 개수를 조절하는 
			// select 입력양식에 change 이벤트 발생 시 실행할 코드 설정
			//-----------------------------------------------------------------------	
			$("[name=rowCntPerPage]").change(function(){
				//-----------------------------------------------------------------------
				// name=boardListForm 을 가진 폼태그의 action 값의 URL 주소로 이동하기
				// 즉 /erp/boardList.do 로 이동하기
				//-----------------------------------------------------------------------
				document.boardListForm.submit();
			});
			//-----------------------------------------------------------------------
			// [검색] 버튼 클릭 시 실행할 코드 설정
			//-----------------------------------------------------------------------
			$(".searchBoard").click(function(){
				if( $("[name=keyword]").val().split(" ").join("")=="" ){
					alert("검색 단어가 없어 검색을 할 수 없습니다.");
					return;
				}
				// $("[name=selectPageNo]").val("1");
				// document.boardListForm.submit();
				goBoardListForm();
			});
			//-----------------------------------------------------------------------
			// [모두 검색] 버튼 클릭 시 실행할 코드 설정
			//-----------------------------------------------------------------------
			$(".searchBoardAll").click(function(){
				$("[name=keyword]").val("");
				// $("[name=selectPageNo]").val("1");
				document.boardListForm.submit();
			});
		});
		//-----------------------------------------------------------------------
		// [게시판 목록 화면] 으로 이동하는 함수 선언
		//-----------------------------------------------------------------------
		function goBoardListForm(){
			//-----------------------------------------------------------------------
			// name=boardListForm 을 가진 form 태그안의 action 에 설정된 URL 로 이동하기
			// 이동 시 form 태그안의 모든 입력 양식이 파라미터값으로 전송된다.
			//-----------------------------------------------------------------------
			document.boardListForm.submit();
		}
		
		//-----------------------------------------------------------------------
		// [게시판 입력 화면]으로 이동하는 함수 선언
		//-----------------------------------------------------------------------
		function goBoardRegForm(){
			//-----------------------------------------------------------------------
			// name=boardRegForm 을 가진 form 태그안의 action 에 설정된 URL 로 이동하기
			// 이동 시 form 태그안의 모든 입력 양식이 파라미터값으로 전송된다.
			//-----------------------------------------------------------------------
			document.boardRegForm.submit();
		}
		//-----------------------------------------------------------------------
		// [게시판 상세 보기 화면]으로 이동하는 함수 선언
		//-----------------------------------------------------------------------
		function goBoardContentForm( b_no ){
			// alert(b_no);
			// return;
			//-----------------------------------------------------------------------
			// 클릭한 게시판 글의 PK 값을 name=boardContentForm 가진
			// form 태그안의 name=b_no 를 가진 입력 양식에 삽입하기
			//-----------------------------------------------------------------------
			$("[name=boardContentForm] [name=b_no]").val(b_no);
			//-----------------------------------------------------------------------
			// name=boardContentForm 을 가진 form 태그안의 action 에 설정된 URL 로 이동하기
			// 이동 시 form 태그안의 모든 입력 양식이 파라미터값으로 전송된다.
			//-----------------------------------------------------------------------
			document.boardContentForm.submit();
		}
	</script>
</head>

<body><center><br><br>
<!----------------------------------------------------------------------->
<!-- [게시판 목록]을 출력하는 form 태그 선언 -->
<!----------------------------------------------------------------------->
<form name="boardListForm" method="post" action="/erp/boardList.do">
	<input type="hidden" name="selectPageNo">
	
	<!----------------------------------------------------------------------->
	<!-- [전체 글 수], [글쓰기] 링크 글씨 출력 -->
	<!----------------------------------------------------------------------->
	<!-- <a href="javascript:goBoardRegForm();">[새 글쓰기]</a> -->
	<table class="tbcss1" border=1 cellpadding=5 bgcolor="#FAFAFA" width=630>
		<tr>
			<th>[게시판]
			<th>[전체 글 수] : ${requestScope.boardListAllCnt}
			<th><span style="cursor:pointer" onclick="goBoardRegForm();">[새 글쓰기]</span>
					&nbsp;&nbsp;&nbsp;&nbsp;
				<select name="rowCntPerPage">
					<option value="10">10
					<option value="15">15
					<option value="20">20
					<option value="25">25
					<option value="30">30
					<option value="35">35
					<option value="40">40
				</select>행보기
	</table>
	&nbsp;&nbsp;&nbsp;&nbsp; 
	<!----------------------------------------------------------------------->
	<!-- 페이징 번호 출력(s) -->
	<!----------------------------------------------------------------------->
	
	<!----------------------------------------------------------------------->
	<!-- 검색 결과물의 개수가 1개 이상이면 -->
	<!----------------------------------------------------------------------->
	<c:if test="${boardListAllCnt>0}">
		<!-- 만약 [시작페이지 번호]가 [화면당 보이는 페이지 번호 개수]보다 크면 -->
		<!-- [처음], [이전] 글씨 보이게 하고, 클릭하면 원하는 페이지번호를 hidden 입력 양식에 담고 -->
		<!-- 현재 페이지로 다시 이동하기 -->
		<c:if test="${beginPageNo>pageNoCntPerPage}">
				<a href="javascript:$('[name=selectPageNo]').val('1');goBoardListForm();">[처음]</a>
				<a href="javascript:$('[name=selectPageNo]').val('${beginPageNo-1}');goBoardListForm();">
				[이전]&nbsp;&nbsp;</a>
		</c:if>	
		<!-- [시작페이지 번호]부터 [마지막 페이지 번호]까지 페이지번호를 출력하기 -->
		<!-- 선택된 페이지 번호는 번호만 출력하고 클릭하지 못하게 하고 -->
		<!-- 선택 안된 페이지 번호는 대괄호로 감싸 출력하고 클릭하면 원하는 -->
		<!-- 원하는 페이지번호를 hidden 입력 양식에 담고 현재 페이지로 다시 이동하기 -->
		<c:forEach var="pageNo" begin="${beginPageNo}" end="${endPageNo}">
			<c:if test="${selectPageNo!=pageNo}">
				<a href="javascript:$('[name=selectPageNo]').val('${pageNo}');goBoardListForm()">[${pageNo}]</a>
			</c:if>
			<c:if test="${selectPageNo==pageNo}">
				${pageNo}
			</c:if>
		</c:forEach>
		<!-- 만약 현재 화면에서 보이는 [끝 페이지 번호]가 [맨 마지막 페이지 번호]보다 작으면 -->
		<!-- [다음], [마지막] 글씨 보이게 하고, 클릭하면 원하는 페이지번호를 hidden 입력 양식에 담고 -->
		<!-- 현재 페이지로 다시 이동하기 -->	
			<c:if test="${endPageNo<lastPageNo}">
				<a href="javascript:$('[name=selectPageNo]').val('${endPageNo+1}');goBoardListForm();">
				&nbsp;&nbsp;[다음]</a>
				<a href="javascript:$('[name=selectPageNo]').val('${lastPageNo}');goBoardListForm();">
				[마지막]</a>
			</c:if>
	</c:if>
	
	<!----------------------------------------------------------------------->
	<!-- EL 문법으로 HttpServletRequest 객체에 boardListAllCnt 라는 키값으로 저장된 데이터를 EL 문법으로 표현하기 -->
	<!----------------------------------------------------------------------->
	<!-- ${requestScope.boardListAllCnt}개 -->
	<!----------------------------------------------------------------------->
	<!-- [게시판 검색 결과물] 출력 -->
	<!----------------------------------------------------------------------->
	<table class="tbcss2 boardList" border="1" bordercolor="#000000" cellpadding="3">
		<tr bgcolor=#C6C6C6>
			<th width="50">번호
			<th width="250">제목
			<th width="100">작성자
			<th width="150">작성일
			<th width="50">조회수
	<!----------------------------------------------------------------------->
	<!-- HttpServletRequest 객체에 boardList 라는 키값으로 저장된 List<Map<String,String>> 객체 안의 -->
	<!-- 데이터를 커스텀 태그의 반복문과 EL 문법으로 표현하기 -->
	<!-- List<Map<String,String>>객체 안의 Map<String,String> 객체를 변수 board 에 담아 -->
	<!-- n번의 반복문이 실행된다. -->
	<!-- board 에 저장된 Map<String,String> 객체에 저장된 데이터를 꺼낼땐 -->
	<!-- 달러문자{board.키값}으로 표현한다. -->
	<!----------------------------------------------------------------------->
	<c:forEach var="board" items="${boardList}" varStatus="loopTagStatus">
		<tr align=center style="cursor:pointer" onClick="goBoardContentForm(${board.b_no});">
			 <td>${beginRowNo_desc - loopTagStatus.index} 
			<%-- <td>${loopTagStatus.count} --%>
			<td align=left>
				<c:forEach begin="0" end="${board.print_level}">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</c:forEach>
				<c:if test="${board.print_level>0}">ㄴ</c:if>
				${board.subject}
			<td>${board.writer}
			<td>${board.reg_date}
			<td>${board.readcount}
				<input type="hidden" name="content" value="${board.content}">
	</c:forEach>
	</table>
	
	<select name=keywordTarget>
		<option value="subject" selected>제목
		<option value="content">내용
		<option value="writer">작성자
		
	</select>
	
	<input type="text" name="keyword">
	
	<input type="checkbox" name="issue" value="유치원">유치원
	
	<input type="button" value="검색" class="searchBoard">&nbsp;
	<input type="button" value="모두 검색 / 새로 고침" class="searchBoardAll">
	
	<input type="button" value="로그인화면으로" 
				onclick="location.replace('/erp/loginForm.do')">
	
</form>
<!----------------------------------------------------------------------->
<!-- [게시판 등록 화면]으로 이동하는 주소를 가진 form 태그 선언하기 -->
<!-- 이 form 태그 내부의 입력양식은 파라미터값으로 이동 페이지로 전달된다. -->
<!----------------------------------------------------------------------->
<form name="boardRegForm" method="post" action="/erp/boardRegForm.do">
</form>
<!----------------------------------------------------------------------->
<!-- [선택한 게시판 상세보기 화면]으로 이동하는 주소를 가진 form 태그 선언하기 -->
<!-- 이 form 태그 내부의 입력양식은 파라미터값으로 이동 페이지로 전달된다. -->
<!----------------------------------------------------------------------->
<form name="boardContentForm" method="post" action="/erp/boardContentForm.do">
	<!----------------------------------------------------------------------->
	<!-- [게시판 글 고유번호]가 저장되는 [hidden 입력 양식] 선언. -->
	<!----------------------------------------------------------------------->
	<input type="hidden" name="b_no">
</form>
</body>
</html>