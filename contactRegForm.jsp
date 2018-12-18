<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<!--JSP 페이지 처리 방식 선언-->
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<!--현재 페이지에 common.jsp 파일 내의 소스 삽입-->
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<%@include file="common2.jsp"%>

<html>
<head>
<script>
	//alert($);
	//**********************************************
	// body 태그를 모두 실행한 후에 실행할 자스 코드 설정
	//**********************************************
	 function contactRegFormCheck( ){
      var contactRegFormObj = $("[name=contactRegForm]");
      try{
         //---------------------------------------
         // 연락처명 유효성 체크
         //---------------------------------------
         var contact_name = contactRegFormObj.find("[name=contact_name]").val( ); // 입력한 연락처명 가져오기
         // 만약 연락처명이 한글 또는 영어가 아니면 경고하고, 지우고 ,함수 멈추기         
         if( new RegExp(/^[가-힣a-zA-Z0-9]{2,20}$/).test(contact_name)==false  ){
            alert( "연락처명는 공백 없이 영대소문자 또는 한글 또는 숫자만 입력돼야 합니다.");
            contactRegFormObj.find("[name=contact_name]").val( "" );
            return;
         }
         //---------------------------------------
         // 전화번호 유효성 체크
         //---------------------------------------
         var phone = contactRegFormObj.find("[name=phone]").val( );   // 입력한 전화번호 가져오기
         // 만약 연락처명이 한글 또는 영어가 아니면 경고하고, 지우고 ,함수 멈추기
         if( new RegExp( /^[0-9]{3,30}$/ ).test(phone)==false ){
            alert("전화번호는 - 없이 숫자만 입력 요망!");
            contactRegFormObj.find("[name=phone]").val( "" );
            return;
         }
         //---------------------------------------
         // 사업분야 유효성 체크
         //---------------------------------------
         // 사업분야 체크개수 가져오기
         var saup_fieldCnt = contactRegFormObj.find("[name=saup_field]").filter(":checked").length;
         // 사업분야 체크개수가 0개면 경고하고, 함수 멈추기
         if( saup_fieldCnt==0 ){
            alert( "연락처 사업분야는 반드시 1개 이상 체크해야합니다.");
            return;
         }
         if(confirm("정말 등록할까요")==false ){ return; }
         //---------------------------------------
         // <방법2>현재 화면에서 페이지 이동 없이 서버쪽 "/erp/contactRegProc2.do"  을 호출하여
         //       연락처 입력 후 입력 행의 개수를 받아 처리한다.
         //---------------------------------------
         $.ajax({
            // ------------------
            // 호출할 서버쪽 URL 주소 설정
            // ------------------
            url : "/erp/contactRegProc.do"
            // ------------------
            // 전송 방법 설정
            // ------------------
            ,type : "post"
            // ------------------
            // 서버에 보낼 파라미터명과 파라미터값을 설정
            // ------------------
            ,data : contactRegFormObj.serialize( )   
            // ------------------
            // 서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
            // 익명함수의 매개변수 contactRegCnt 에는 연락처 입력 적용행의 개수가 들어온다.
            // ------------------
            ,success : function( contactRegCnt ){
               // 연락처 입력 적용 행의 개수가 1개 이상이면
               // 즉 연락처 등록이 성공했으면
               if(contactRegCnt>0){
                  // confirm 상자 띠우고
                  if(confirm("연락처 등록 성공! 다른 연락처를 입력 하시겠습니까?")==true){
                     document.contactRegForm.reset();
                  }
                  else{
                     location.replace("/erp/contactSearchForm.do");
                  }
               }
               // 연락처 입력 적용 행의 개수가 1개 미만이면
               // 즉 연락처 등록이 실패했으면
               else{
                  alert("연락처 등록 실패! 관리자에게 문의 바람!")
                  location.replace("/erp/contactSearchForm.do");
               }
            } 
            // ------------------
            // 서버의 응답을 못 받았을 경우 실행할 익명함수 설정.
            // ------------------
            ,error : function(  ){
               alert("서버접속 실패! 관리자에게 문의 바람!");
            }
         });
         
      }catch(e){
         alert( "contactRegFormCheck( ) 함수 예외 발생!" );
      }
   }
</script>
</head>

<body><center>
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<!--[연락처 등록] 화면을 출력하는 form 태그 선언-->
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<form name="contactRegForm" method="post"  action="/erp/contactRegProc.do">
	<b>[연락처 등록]</b>
	<table class="tbcss1">
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
	</table>
	<div style="height:6"></div>
	<input type="button" value="   등록   " class="xxx"  onClick="contactRegFormCheck( )">
	<span style="cursor:pointer" onclick="location.replace('/erp/contactSearchForm.do')">[연락처목록으로]</span>
</form>


</body>
</html>




