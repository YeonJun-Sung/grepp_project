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
var month_check = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
var day_check = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
var key = "";
var priority_max = 0;

$(document).ready(function(){
	getTodoList();
	
	$("#todo_detail_priority_edit, #todo_detail_priority_add, .priority_add").on("keyup", function(){
		if($(this).val() > priority_max + 1)	$(this).val(priority_max + 1)
	});
	
	// TODO 추가 버튼 이벤트
	$("#todo_detail_add_bt").on("click", function(){
		$(".todo_detail_view").hide();
		$(".todo_detail_edit").hide();
		$(".todo_detail_div").show();
		$(".todo_detail_add").show();
		
		$("#todo_detail_title_add").val("");
		$("#todo_detail_contents_add").val("");
		$("#todo_detail_deadline_add").val("");
		$("#todo_detail_priority_add").val("");
		
    	$("#todo_detail_title").text("");
		$("#todo_detail_contents").text("");
		$("#todo_detail_deadline").text("");
		$("#todo_detail_priority").text("");
	});
	
	// TODO List 중 하나 선택 이벤트
	$("body").on("click", "#todo_list_tbody tr", function(){
		key = $(this).data("key");

		$(".todo_detail_edit").hide();
		$(".todo_detail_add").hide();
		$(".todo_detail_div").show();
		$(".todo_detail_view").show();
		
		$("#todo_detail_title").attr("data-key", key);
		
		$.ajax({
	        type : "POST"
	        , url : "/grepp/todo/getTodoDetail.do"
	        , data : {
	        	list_key: key
	        }
	        , success : function(data) {
	        	$("#todo_detail_title").text(data.list_title);
       			$("#todo_detail_contents").text(data.list_content);
       			if(data.list_date != null || data.list_date != "")
	   				$("#todo_detail_deadline").text(data.list_date);
      			if(data.list_pri != null || data.list_pri != "")
   					$("#todo_detail_priority").text(data.list_pri);
	        }
	        , error : function(e) {
	        	console.log(e.result);
	        }
	    });
	});
	
	// TODO 완료 이벤트
	$("body").on("click", "#todo_detail_complete_bt", function(){
		$.ajax({
	        type : "POST"
	        , url : "/grepp/todo/completeTodo.do"
	        , data : {
	        	list_key: key
	        }
	        , success : function(data) {
	    		$(".todo_detail_div").hide();
	    		$(".todo_detail_view").hide();
	    		$(".todo_detail_edit").hide();
	    		$(".todo_detail_add").hide();
      			getTodoList();
      			key = "";
	        }
	        , error : function(e) {
	        	console.log(e.result);
	        }
	    });
	});
	
	// TODO 수정 이동 이벤트
	$("body").on("click", "#todo_detail_edit_bt", function(){
		$(".todo_detail_view").hide();
		$(".todo_detail_add").hide();
		$(".todo_detail_div").show();
		$(".todo_detail_edit").show();
		
    	$("#todo_detail_title").text("");
		$("#todo_detail_contents").text("");
		$("#todo_detail_deadline").text("");
		$("#todo_detail_priority").text("");
		
		$.ajax({
	        type : "POST"
	        , url : "/grepp/todo/getTodoDetail.do"
	        , data : {
	        	list_key: key
	        }
	        , success : function(data) {
	        	console.log(data)
	        	$("#todo_detail_title_edit").val(data.list_title);
       			$("#todo_detail_contents_edit").val(data.list_content);
       			if(data.list_date != null || data.list_date != "")
	   				$("#todo_detail_deadline_edit").val(data.list_date);
      			if(data.list_pri != null || data.list_pri != "")
   					$("#todo_detail_priority_edit").val(data.list_pri);
	        }
	        , error : function(e) {
	        	console.log(e.result);
	        }
		});
	});
	
	// TODO 삭제 이벤트
	$("body").on("click", "#todo_detail_delete_bt", function(){
		$.ajax({
	        type : "POST"
	        , url : "/grepp/todo/deleteTodo.do"
	        , data : {
	        	list_key: key
	        }
	        , success : function(data) {
	    		$(".todo_detail_div").hide();
	    		$(".todo_detail_view").hide();
	    		$(".todo_detail_edit").hide();
	    		$(".todo_detail_add").hide();
      			getTodoList();
      			key = "";
	        }
	        , error : function(e) {
	        	console.log(e.result);
	        }
	    });
	});
	
	// TODO 생성 이벤트
	$("body").on("click", "#todo_detail_create_bt", function(){
		var title = $("#todo_detail_title_add").val();
		var contents = $("#todo_detail_contents_add").val();
		var deadline = $("#todo_detail_deadline_add").val();
		var priority = $("#todo_detail_priority_add").val();
		
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var day = today.getDate();
		var date = deadline.split("-");

		if(title == null || title == "")
			alert("제목을 입력해주세요.")
		else if(contents == null || contents == "")
			alert("내용을 입력해주세요.")
		else if(deadline == null || deadline == "")
			createTodo(title, contents, deadline, priority);
		else if(date.length != 3)
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else if(parseInt(date[0]) < year)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if(parseInt(date[0]) == year && parseInt(date[1]) < month)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if(parseInt(date[0]) == year && parseInt(date[1]) == month && parseInt(date[2]) < day)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if($.inArray(date[1], month_check) == -1)
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else if(parseInt(date[2]) > day_check[parseInt(date[1]) - 1])
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else
			createTodo(title, contents, deadline, priority);
	});
	
	// TODO 저장 이벤트
	$("body").on("click", "#todo_detail_save_bt", function(){
		var title = $("#todo_detail_title_edit").val();
		var contents = $("#todo_detail_contents_edit").val();
		var deadline = $("#todo_detail_deadline_edit").val();
		var priority = $("#todo_detail_priority_edit").val();

		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var day = today.getDate();
		var date = deadline.split("-");

		if(title == null || title == "")
			alert("제목을 입력해주세요.")
		else if(contents == null || contents == "")
			alert("내용을 입력해주세요.")
		else if(deadline == null || deadline == "")
			saveTodo(title, contents, deadline, priority);
		else if(date.length != 3)
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else if(parseInt(date[0]) < year)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if(parseInt(date[0]) == year && parseInt(date[1]) < month)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if(parseInt(date[0]) == year && parseInt(date[1]) == month && parseInt(date[2]) < day)
			alert("마감기한을 '" + year + "-" + ((month < 10)?("0"+month):month) + "-" + ((day < 10)?("0"+day):day) + "' 이후로 입력해주세요.");
		else if($.inArray(date[1], month_check) == -1)
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else if(parseInt(date[2]) > day_check[parseInt(date[1]) - 1])
			alert("마감기한을 'YYYY-MM-DD' 형식에 맞춰 입력해주세요.");
		else
			saveTodo(title, contents, deadline, priority);
	});
	
	// 10개 이전 페이지 목록 이동
	$("#paging_pre").on("click", function(){
		var offset = parseInt($("#page_offset").val());
		if(offset != 0) {
        	var rtvHtml = "";
        	offset = offset - 10;
        	$("#page_offset").val(offset);
        	for(var i = offset;i < 10;i++) {
        		var page = parseInt(i) + 1;
        		rtvHtml += " <span class='paging_a' data-page='" + page + "'>";
        		rtvHtml += "" + page;
        		rtvHtml += "</span> ";
        	}
        	$("#paging_list").empty();
        	$("#paging_list").append(rtvHtml);
		}
	});
	
	// 10개 이후 페이지 목록 이동
	$("#paging_aft").on("click", function(){
		var max_page = parseInt($("#max_page").val());
		var offset = parseInt($("#page_offset").val()) + 10;
		if(max_page > offset) {
        	var rtvHtml = "";
        	$("#page_offset").val(offset);
        	for(var i = offset;i < max_page;i++) {
        		var page = parseInt(i) + 1;
        		rtvHtml += " <span class='paging_a' data-page='" + page + "'>";
        		rtvHtml += "" + page;
        		rtvHtml += "</span> ";
        	}
        	$("#paging_list").empty();
        	$("#paging_list").append(rtvHtml);
		}
	});
	
	// 페이지 로드
	$("body").on("click", ".paging_a", function(){
		var page = $(this).data("page");
		$("#page").val(page);
		getTodoList();
	});
	
	// 우선순위 추가
	$("body").on("click", ".priority_add_bt", function(){
		var priority = $(this).parents("td").children(".priority_add").val();
		var list_key = $(this).parents("tr").data("key");
		console.log(key);
		if(priority == null)
			alert("우선순위를 입력해 주세요.");
		else {
			$.ajax({
				type : "POST"
		        , url : "/grepp/todo/removePriority.do"
		        , data : {
		        	list_key: list_key
		        }
		        , success : function(data) {
		        }
		        , error : function(e) {
		        	console.log(e.result);
		        }
		    });
			orderPriority(priority);
			$.ajax({
				type : "POST"
		        , url : "/grepp/todo/addPriority.do"
		        , data : {
		        	priority: priority
		        	, list_key: list_key
		        }
		        , success : function(data) {
		        	getTodoList();
		        }
		        , error : function(e) {
		        	console.log(e.result);
		        }
		    });
		}
	});
});

// TODO List 총 페이지 수와 불러오는 함수
function getTodoList() {
	$.ajax({
        type : "POST"
        , url : "/grepp/todo/getPaging.do"
        , data : {}
        , success : function(data) {
        	var rtvHtml = "";
        	$("#max_page").val(data);
        	var offset = $("#page_offset").val();
        	var limit = (data < 10)?data:10;
        	for(var i = offset;i < limit;i++) {
        		var page = parseInt(i) + 1;
        		rtvHtml += " <span class='paging_a' data-page='" + page + "'>";
        		rtvHtml += "" + page;
        		rtvHtml += "</span> ";
        	}
        	$("#paging_list").empty();
        	$("#paging_list").append(rtvHtml);
        }
        , error : function(e) {
        	console.log(e.result);
        }
    });
	
	$.ajax({
        type : "POST"
        , url : "/grepp/todo/getMaxPriority.do"
        , data : {}
        , success : function(data) {
        	priority_max = data
        }
        , error : function(e) {
        	console.log(e.result);
        }
    });
	
	$.ajax({
        type : "POST"
        , url : "/grepp/todo/getTodoList.do"
        , data : {
        	page: $("#page").val()
        }
        , success : function(data) {
        	var rtvHtml = "";
        	for(var i = 0;i < data.length;i++){
        		var d = data[i];
            	rtvHtml += "<tr style='height:66px;' data-key='" + d.list_key + "'>";
            	rtvHtml += "<td>";
            	if(parseInt(d.list_stat) == 3){
            		rtvHtml += "완료";
            	}
            	else if(d.list_pri == null || d.list_pri == "") {
                	rtvHtml += "<input type='number' class='priority_add' value='' style='width:30px;' min='1'>";
                	rtvHtml += "<input type='button' class='priority_add_bt' value='추가'>";
            	}
            	else {
            		rtvHtml += "" + d.list_pri;
                	rtvHtml += "<input type='button' class='priority_up_bt' value='△'>";
                	rtvHtml += "<input type='button' class='priority_down_bt' value='▽'>";
            	}
            	rtvHtml += "</td>";
            	rtvHtml += "<td>";
            	rtvHtml += "" + d.list_title;
            	rtvHtml += "</td>";
            	rtvHtml += "<td data-status='" + d.list_stat + "'>";
            	if(d.list_date != null && d.list_date != "")
            		rtvHtml += "" + d.list_date;
            	rtvHtml += "</td>";
            	rtvHtml += "</tr>";
        	}
        	if(data.length < 10)
        		rtvHtml += "<tr><td colspan='3'></td></tr>";

        	$("#todo_list_tbody").empty();
        	$("#todo_list_tbody").prepend(rtvHtml);
        }
        , error : function(e) {
        	console.log(e.result);
        }
    });
}

//TODO 저장 함수
function saveTodo(title, contents, deadline, priority) {
	$.ajax({
     type : "POST"
     , url : "/grepp/todo/saveTodoList.do"
     , data : {
     	title: title
     	, contents: contents
     	, deadline: deadline
     	, priority: priority
     	, list_key: key
     }
     , success : function(data) {
     	$("#todo_detail_title_edit").val("");
     	$("#todo_detail_contents_edit").val("");
			$("#todo_detail_deadline_edit").val("");
			$("#todo_detail_priority_edit").val("");
			$("#todo_detail_title_edit").attr("data-key", "");
			getTodoList();
			alert("저장되었습니다.");
     }
     , error : function(e) {
     	console.log(e.result);
     }
 });
}

//TODO 생성 함수
function createTodo(title, contents, deadline, priority) {
	$.ajax({
     type : "POST"
     , url : "/grepp/todo/createTodoList.do"
     , data : {
     	title: title
     	, contents: contents
     	, deadline: deadline
     	, priority: priority
     }
     , success : function(data) {
     	$("#todo_detail_title_edit").val("");
     	$("#todo_detail_contents_edit").val("");
			$("#todo_detail_deadline_edit").val("");
			$("#todo_detail_priority_edit").val("");
			$("#todo_detail_title_edit").attr("data-key", "");
			getTodoList();
			alert("저장되었습니다.");
     }
     , error : function(e) {
     	console.log(e.result);
     }
 });
}

function orderPriority(num) {
	$.ajax({
        type : "POST"
        , url : "/grepp/todo/orderPriority.do"
        , data : {
        	num: num
        }
        , success : function(data) {
        	getTodoList();
        }
        , error : function(e) {
        	console.log(e.result);
        }
    });
}
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

<input id='page' type='hidden' value='1'>
<input id='max_page' type='hidden' value=''>
<input id='page_offset' type='hidden' value='0'>
<div class='main_page_html'>
	<table class='main_table'>
		<colgroup>
			<col width='50%'/>
			<col width='50%'/>
		</colgroup>
		<tr>
			<td id='todo_list_title'>
				TODO List
				<div class='todo_button'>
					<input type='button' id='todo_detail_add_bt' value='추가'>
				</div>
			</td>
			<td>
				<div class='todo_button'>
					<input type='button' class='todo_detail_view' id='todo_detail_complete_bt' value='완료'>
					<input type='button' class='todo_detail_view' id='todo_detail_edit_bt' value='수정'>
					<input type='button' class='todo_detail_view' id='todo_detail_delete_bt' value='삭제'>
					<input type='button' class='todo_detail_edit' id='todo_detail_save_bt' value='저장'>
					<input type='button' class='todo_detail_add' id='todo_detail_create_bt' value='생성'>
				</div>
			</td>
		</tr>
		<tr>
			<td id='todo_list' style='vertical-align: top;text-align: center;'>
				<table class='todo_list_table'>
					<colgroup>
						<col width='100px'/>
						<col width='550px'/>
						<col width='150px'/>
					</colgroup>
					<thead>
						<tr style='height:40px;'>
							<th>우선순위</th>
							<th>제목</th>
							<th>마감기한</th>
						</tr>
					</thead>
					<tbody id='todo_list_tbody' style='height:660px;'>
					</tbody>
				</table>
				<div class='margin_top15' id='paging'>
					<input type='button' id='paging_pre' value='<'> <span id='paging_list'></span> <input type='button' id='paging_aft' value='>'>
				</div>
			</td>
			<td id='todo_detail' style='vertical-align: top;'>
				<div class='todo_detail_div'>
					<table class='todo_detail_table'>
						<colgroup>
							<col width='150px'/>
							<col width='650px'/>
						</colgroup>
						<tbody>
							<tr style='height:40px;'>
								<td><b>제목</b></td>
								<td>
									<span class='todo_detail_view' id='todo_detail_title'></span>
									<input type='text' class='todo_detail_edit' id='todo_detail_title_edit'>
									<input type='text' class='todo_detail_add' id='todo_detail_title_add'>
								</td>
							</tr>
							<tr style='height:660px;'>
								<td><b>내용</b></td>
								<td>
									<div class='todo_detail_view' id='todo_detail_contents'></div>
									<textarea class='todo_detail_edit' id='todo_detail_contents_edit'></textarea>
									<textarea class='todo_detail_add' id='todo_detail_contents_add'></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<div class='margin_top15'>
						마감기한 : 
						<span class='todo_detail_view' id='todo_detail_deadline'></span>
						<input type='text' class='todo_detail_edit' id='todo_detail_deadline_edit' placeholder='YYYY-MM-DD'>
						<input type='text' class='todo_detail_add' id='todo_detail_deadline_add' placeholder='YYYY-MM-DD'>
						<span style='margin-left:50px;'>우선순위 : </span>
						<span class='todo_detail_view' id='todo_detail_priority'></span>
						<input type='number' class='todo_detail_edit' id='todo_detail_priority_edit' min='1'>
						<input type='number' class='todo_detail_add' id='todo_detail_priority_add' min='1'>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>