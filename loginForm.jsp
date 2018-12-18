<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!----------------------------------------------------------------------->
<!-- JSP 기술의 한 종류인 [Include Directive]를 이용하여 common.jsp 파일 내의 소스를 삽입하기 -->
<!-- JSP 페이지에서 공통으로 선언하는 코딩은 따로 뺀후 이렇게 수입하면 좋다 -->
<!----------------------------------------------------------------------->
<%@include file="/WEB-INF/views/common1.jsp"%>
<!-- ================================================================================== -->
<!-- c코어 터스텀 태그를 사용하여 HttpSeddion 객체에 msg 이란 키값으로 저장된 놈이 있으면 확인하고 있으면 자스로 경고 문구 보여줘... -->
<!-- ================================================================================== -->
<c:if test="${!empty sessionScope.msg}">
<script>
	alert("${sessionScope.msg}")
</script>
<!--c코어 터스텀 태그를 사용하여 HttpSession 객체에 msg 이란 키값으로 저장된 놈을 지우기 -->
	<c:remove var="msg" scope="session"/>
	
</c:if>






<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>로그인</title>
		<script>
			//----------------------------------------------------------------------- 
			// body 태그 안의 소스를 모두 실행한 후에 실행할 자스 코드 설정
			//-----------------------------------------------------------------------
			$(document).ready(function(){
				//-----------------------------------------------------------------------
				//Cookie 객체에 admin_id 라는 쿠키명의 쿠키값을 꺼내서
				//ame = admin_id 가진 태그의 value값에 삽입하기
				//EL로 Cookie 객체에서 쿠키값을 꺼내는 방법    =>  달러표시{cookie.쿠키명.value}
				//-----------------------------------------------------------------------
				$("[name=admin_id]").val("${cookie.admin_id.value}");
				//-----------------------------------------------------------------------
				//Cookie 객체에 pwd 라는 쿠키명의 쿠키값을 꺼내서
				//ame = pwd 가진 태그의 value값에 삽입하기
				//EL로 Cookie 객체에서 쿠키값을 꺼내는 방법    =>  달러표시{cookie.쿠키명.value}
				//-----------------------------------------------------------------------
				$("[name=pwd]").val("${cookie.pwd.value}");
				//-----------------------------------------------------------------------
				//Cookie 객체에 admin_id 라는 쿠키명의 쿠키값이 있다면
				//name=is_login 가진 태그를 체크하기
				//-----------------------------------------------------------------------
				<c:if test="${!empty cookie.admin_id.value}">
					$('[name=is_login]').prop("checked",true);
				</c:if>
				//-----------------------------------------------------------------------
				// name=loginForm 가진 태그 안의 class=login 가진 태그에
				// click 이벤트 발생 시 실행할 코드 설정하기
				//-----------------------------------------------------------------------
				$("[name=loginForm] .login").click(function(){
					checkLoginForm();
				})
				
				
				//-----------------------------------------------------------------------
				// 아이디와 암호를 넣어주기
				// 테스트 시 아이디와 암호를 손으로 넣기 귀찮아서 하는 짓거리임
				// 테스트가 끝나면 없애야함.
				//-----------------------------------------------------------------------
				//$("[name=admin_id]").val("abc");
				//$("[name=pwd]").val("123");
			});
			//-----------------------------------------------------------------------
			// 아이디와 암호의 유효성을 체크하고 비동기 방식으로 웹서버와 통신하는 함수 선언
			//-----------------------------------------------------------------------
			function checkLoginForm(){
				// alert("쉬는 시간")
				//-----------------------------------------------------------------------
				// 입력한 [아이디] 를 가져와 변수에 저장
				//-----------------------------------------------------------------------
				var admin_id = $("[name=admin_id]").val();
					// 오른쪽도 가능 -> var admin_id = document.loginForm.admin_id.value;
					// 오른쪽도 가능 -> var admin_id = $(".admin_id").val();
				//-----------------------------------------------------------------------
				// 입력한 [암호] 를 가져와 변수에 저장
				//-----------------------------------------------------------------------
				var pwd = $("[name=pwd]").val();
					// 오른쪽도 가능 -> var admin_id = document.loginForm.pwd.value;
					// 오른쪽도 가능 -> var admin_id = $(".pwd").val();
					// $(".msg").text( admin_id +" / "+pwd )
				//-----------------------------------------------------------------------
				// 관리자 아이디를 입력 안했으면 경고하고 함수 중단
				//-----------------------------------------------------------------------
				if( admin_id.split(" ").join("")==""){
					alert("관리자 아이디 입력 요망");
					$("[name=admin_id]").val("");
					return;
				}
				//-----------------------------------------------------------------------
				// 암호를 입력 안했으면 경고하고 함수 중단
				//-----------------------------------------------------------------------
				if( pwd.split(" ").join()==""){
					$("[name=pwd]").val("");
					alert("암호 입력 요망");
					return;
				}
				//-----------------------------------------------------------------------
				// 동기 방식으로 웹서버 /erp/loginProc.do로 접속하기
				// 비동기를 쓰기로 했으므로 참조만 할 것.
				//-----------------------------------------------------------------------
				// name="loginForm" 을 가진 폼테크 내부의
				// 입력 양식값을 파라미터값으로 가지고
				// 웹서버 /erp/loginProc.do 로 접속하기
				//-----------------------------------------------------------------------
				// document.loginForm.submit();

				//-----------------------------------------------------------------------
				// 현재 화면에서 페이지 이동 없이(=비동기 방식으로)
				// 서버쪽으로 "/erp/loginProc.do" 로 접속하여
				// HTML 소스를 받아 실행하기
				//-----------------------------------------------------------------------
				$.ajax({
					// 서버쪽 호출 URL 주소 지정
					url : "/erp/loginProc.do"
					// form 태그 안의 데이터를 보내는 방법 저장
					, type : "post"
					//서버에 보낼 파라미터명과 파라미터값을 설정
					,data : $("form").filter("[name=loginForm]").serialize()
					//, data : {'admin_id' :admin_id,'pwd':pwd}
						// , date : "admin_id="+admin_id+"&pwd="+pwd
						// , data : $("form").filter("[name=loginForm]").serialize()
						// , data : $("[name=loginForm]").serialize()
					// 서버가 응답 무슨 파일로 응답하는지 지정
					// 서버가 응답할 페이지 종류 html 일경우 생략 가능
					, datatype : "json"
					// 서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정
					// 익명함수의 매개변수 adminCnt 에는 서버가 응답한 로그인 아이디의 존개 개수가 들어온다.
					, success : function( adminCnt ){
						// 로그인 아이디의 존재 개수가 1이면 환영 경고하고 연락처 검색 화면으로 이동하기
						if( adminCnt==1 ){
							// alert("로그인 성공")
							location.replace("/erp/contactSearchForm.do")
						}
						// 로그인 아이디의 존재 개수가 0개면 경고하기
						else if( adminCnt==0 ){
							alert("아이디 암호가 틀립니다");
						}
						// 로그인 아이디의 존재 개수가 음수면 경고하기
						else{
							alert("관리자에게 문의 바람");
						}
						
					}
					// 서버의 응답을 못 받았을 경우 실행할 익명함수 설정
					, error : function(){
						alert("서버 접속 실패입니다");
					}
				});
			}
		</script>
	</head>
	<body><center><br><br><br>
		<div class='msg'></div>
		
		<form name="loginForm" method="post" action="/erp/loginProc.do">
			
			<table class="tbcss1" border=1 cellpadding=20 cellspacing=20><tr><th>
			<b>[로그인]</b>
				<div style="height:6px"></div>
				<table class="tbcss1" border=1 cellpadding=5 cellspacing=0 bordercolor="gray">
					<tr>
						<th align=center bgcolor="${bgcolor1}">아이디
						<td><input type="text" name="admin_id" class="admin_id" size="20">
					<tr>
						<th align=center bgcolor="${bgcolor2}">암 호
						<td><input type="password" class="pwd" name="pwd" size="20">
				</table>
				<div style="height:6px"></div>
				<input type="button" value="로그인" class="login">
				
				<!-- checkbox, radio => 체크하지 않으면 value값이 전송되지 않음 -->	
				<input type="checkbox" name="is_login" value="y">아이디.암호 기억
			</table>
		</form>
	</body>
</html>