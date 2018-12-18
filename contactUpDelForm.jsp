<!--*******************************************************-->
<!--JSP 페이지 처리 방식 선언-->
<!--*******************************************************-->
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--*******************************************************-->
<!--현재 페이지에 common.jsp 파일 내의 소스 삽입-->
<!--*******************************************************-->
<%@include file="common2.jsp"%>


<html>
<head>
<!--*******************************************************-->
<!--만약 수정/삭제할 연락처가  없으면 경고하고 연락처 목록화면으로 이동하기->
<!--*******************************************************-->
<c:if test="${empty contact}">
	<script>
		alert("연락처가 삭제 되었음!")
		location.replace("/erp/contactSearchForm.do")
	</script>
</c:if>

<script>

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// body 태그를 모두 실행한 후 실행할 자스 코드 설정	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	$(document).ready(function(){
		// name=contactUpDelForm 을 가진 form 태그를 관리하는 JQuery 객체 메위주 저장하기
		var contactUpDelFormObj = $("[name=contactUpDelForm]");
		// name=contact_no 을 가진 입력양식에 수정/삭제할 연락처 번호 저장하기
		contactUpDelFormObj.find("[name=contact_no]").val( "${contact.contact_no}");
		// name=contact_name 을 가진 입력양식에 수정/삭제할 연락처명 저장하기
		contactUpDelFormObj.find("[name=contact_name]").val( "${contact.contact_name}");
		// name=phone 을 가진 입력양식에 연락처 수정/삭제할 전화번호 저장하기
		contactUpDelFormObj.find("[name=phone]").val( "${contact.phone}");
		// name=saup_field 을 가진 입력양식에 수정/삭제할 데이터 체크해주기하기
	    <c:forEach var="saup_field" items="${contact.saup_field}">
	    	contactUpDelFormObj.find("[name=saup_field]").filter("[value=${saup_field}]").attr("checked",true);
	    </c:forEach>
	    
	    
	         
	     $("[name=contactSearchForm]").find("[name=selectPageNo]").val ("${param.selectPageNo}");
	
	
	});
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 연락처 수정.삭제 입력양식의 유효성 체크하는 자바스크립트 함수 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function checkContactUpDelForm( upDel ){
		var contactUpDelFormObj = $("[name=contactUpDelForm]");
		try{
			//**********************************************
			// 수정 버튼을 클릭한 경우
			//**********************************************
			if(upDel=="up"){
				contactUpDelFormObj.find("[name=upDel]").val( 'up' );
				//---------------------------------------
				// 연락처명 유효성 체크
				//---------------------------------------
				var contact_name = contactUpDelFormObj.find("[name=contact_name]").val( ); // 입력한 연락처명 가져오기
				// 만약 연락처명이 한글 또는 영어가 아니면 경고하고, 지우고 ,함수 멈추기
				if( new RegExp(/^[가-힣a-zA-Z0-9]{2,20}$/).test(contact_name)==false  ){
				   alert( "연락처명는 공백 없이 영대소문자 또는 한글만 입력돼야 합니다.");
				   contactUpDelFormObj.find("[name=contact_name]").val( "" );
				   return;
				}
				//---------------------------------------
				// 전화번호 유효성 체크
				//---------------------------------------
				var phone = contactUpDelFormObj.find("[name=phone]").val( );   // 입력한 전화번호 가져오기
				// 만약 연락처명이 한글 또는 영어가 아니면 경고하고, 지우고 ,함수 멈추기
				if( new RegExp( /^[0-9]{3,30}$/ ).test(phone)==false ){
				   alert("전화번호는 - 없이 숫자만 입력 요망!");
				   contactUpDelFormObj.find("[name=phone]").val( "" );
				   return;
				}
				//---------------------------------------
				// 사업분야 유효성 체크
				//---------------------------------------
				// 사업분야 체크개수 가져오기
				var saup_fieldCnt = contactUpDelFormObj.find("[name=saup_field]").filter(":checked").length;
				// 사업분야 체크개수가 0개면 경고하고, 함수 멈추기
				if( saup_fieldCnt==0 ){
				   alert( "연락처 사업분야는 반드시 1개 이상 체크해야합니다.");
				   return;
				}
				if(confirm("정말 수정할까요")==false ){ return; }
			}
			//**********************************************
			// 삭제 버튼을 클릭한 경우
			//**********************************************
			else{
				contactUpDelFormObj.find("[name=upDel]").val( 'del' );
				if(confirm("정말 삭제할까요")==false ){ return; }
			}

			//---------------------------------------
			// 현재 화면에서 페이지 이동 없이 서버쪽 "/erp/contactUpDelProc.do"  을 호출하여
			//  [연락처 수정/식제 행 적용 개수]를 받는다.
			//**********************************************
			$.ajax({
				// ----------------------------
				// 호출할 서버쪽 URL 주소 설정
				// ----------------------------
				url : "/erp/contactUpDelProc.do"
				// ----------------------------
				// 전송 방법 설정
				// ----------------------------
				,type : "post"
				//---------------------------------
				// 서버에 보낼 파라미터명과 파라미터값을 설정
				//---------------------------------
				,data : contactUpDelFormObj.serialize( )
				//---------------------------------
				// 서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
				// 익명함수의 매개변수 data 에는 contactUpDelProc.jsp 의 실행 결과물인 html 소스가 문자열로 들어옴.
				//---------------------------------
				,success : function( contactUpDelCnt ){
					// 연락처 수정/삭제 적용 행의 개수가 1개 이상이면
					// 즉 수정/삭제가 성공했으면
					if( contactUpDelCnt>0 ){
						// alert 상자 띠우고 재 등록할지 물어본다
						alert( "연락처 수정/삭제 성공!" );
					}
					// 연락처 수정/삭제 적용 행의 
					else if( contactUpDelCnt==0 ){
						alert( "연락처가 이미 삭제 되었음" );
					}
					else{
						alert( "연락처 등록 실패! 관리자에게 문의 바람!" )
					}
					document.contactSearchForm.submit();
					//location.replace("/erp/contactSearchForm.do");
				}
				//---------------------------------
				// 서버의 응답을 못 받았을 경우 실행할 익명함수 설정.
				//---------------------------------
				,error : function(  ){
					alert("서버와 통신 실패!");
				}
			});

		}catch(e){
			alert( "checkContactUpDelForm( ) 함수 예외 발생!" );
		}
	}

</script>
</head>

<body><center>

		<form name="contactUpDelForm" method="post"  action="/erp/contactUpDelProc.do">
			<b>[연락처 수정/삭제]</b>
			<table cellpadding="5" class="tbcss1" border=1>
				<tr>
					<th>연락처명
					<td><input type="text" name="contact_name" size="15">
				<tr>
					<th>전화
					<td><input type="text" name="phone" size="15">
				<tr>
					<th>사업분야
					<td>
					   <!----------------------------------------->
					   <!--HttpServletRequest 객체에 saup_fieldList 라는 킷값으로 저장된 List<Map> 객체에 저장된 -->
					   <!--[사업분야번호]와 [사업분야이름]을 꺼내어 checkbox 양식에 name 속성값과 value 속성값으로 표현해 출력하기-->
					   <!----------------------------------------->
					   <c:forEach var="saup_field" items="${requestScope.saup_fieldList}">
							<input type="checkbox" name="saup_field"  value="${saup_field.saup_field_code}">${saup_field.saup_field_name}
					   </c:forEach>
				<tr>
					<th>등록일
					<td>${contact.reg_date}
			</table>
			<input type="hidden" name="contact_no">
			<input type="hidden" name="upDel">
		    <table><tr height=2><td></table>
			
			<input type="button" value="수정" onClick="checkContactUpDelForm( 'up' )">
			<input type="button" value="삭제" onClick="checkContactUpDelForm( 'del' )">
			<span style="cursor:pointer" onclick="document.contactSearchForm.submit()">[연락처 목록보기]</span>
		</form>
		
		
		<form name="contactSearchForm" method="post"  action="/erp/contactSearchForm.do">
			
				<input type="hidden" name="selectPageNo">
				
		</form>
		
		
</body>
</html>




