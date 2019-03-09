<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js" /></script>
	<title>Grepp Project - TODO List</title>
</head>
<body>
<script type="text/javascript">
$(document).ready(function(){
	
});
</script>
<!-- 
- 새로운 TODO(제목 + 내용)를 작성한다
- 사용자의 선택에 의해 TODO에는 마감 기한을 넣을 수 있다.
- 우선순위를 조절할 수 있다.
- 완료 처리를 할 수 있다.
- 마감기한이 지난 TODO에 대해 알림을 노출한다.
- TODO 목록을 볼 수 있다.
- TODO 내용을 수정할 수 있다.
- TODO 항목을 삭제할 수 있다.
 -->
<div class='main_page_html'>
	<input button='추가' value='추가'>	
	<ul>
		<il>list1</il>
		<il>list2</il>
		<il>list3</il>
		<il>list4</il>
	</ul>
</div>
</body>
</html>