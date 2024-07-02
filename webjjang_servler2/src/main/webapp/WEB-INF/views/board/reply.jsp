<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags"%>
<div class="card">
	<div class="card-header">
		<!-- 24 06 25 --> <!--  id="replywriteBtn" 06 27 추가 -->
		<span class="btn btn-primary float-right" id="replywriteBtn">등록</span>
		<h3>댓글 리스트</h3>
	</div>
	<div class="card-body">
		<c:if test="${ empty replyList }">
  		데이터가 존재하지 않습니다.
  	</c:if>
		<c:if test="${ !empty replyList }">
			<!-- 데이터가 있는 만큼 반복 처리 시작 -->
			<c:forEach items="${replyList }" var="replyVO">
				<div class="card replyDataRow" data-rno="${replyVO.rno }" style="margin: 5px 0;">
					<div class="card-header">
						<span class="float-right">${replyVO.writeDate }</span> <b class="replyWriter">${replyVO.writer }</b>
					</div>
					<div class="card-body">
						<pre class="replyContent">${replyVO.content }</pre>
					</div>
					<div class="card-footer"> <!--replyUpdateBtn  replyDeleteBtn 추가 0627 -->
						<button class="btn btn-warning replyUpdateBtn">수정</button>
						<button class="btn btn-danger replyDeleteBtn" >삭제</button>
					</div>
				</div>
			</c:forEach>
			<!-- 데이터가 있는 만큼 반복 처리 끝 -->
		</c:if>
	</div>
	<!-- 0628 -->
	<div class="card-footer"> 
			<pageNav:replayPageNav listURI="view.do" pageObject="${replyPageObject}" query="&inc=0"></pageNav:replayPageNav>
	</div>
</div>

<!--  댓글 등록 / 수정 / 삭제를 위한 모달창 -->
<div class="modal" id="boardReplyModal">
	<div class="modal-dialog">
		<div class="modal-content">

			<!-- Modal Header -->
			<div class="modal-header">
				<!--  버튼에 따라서 제목을 수정해서 사용 .text(제목) -->
				<h4 class="modal-title">Modal Heading</h4>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>

			<!-- 데이터를 넘기는 form tag -->
			<form id="boardReplyForm" method="post">
				<input type="hidden" name="rno" id="rno"> 
				<input type="hidden" name="no" value="${param.no }">
				
				<!-- 페이지 정보 보내기 -->
				<input type="hidden" name="page" value="${param.page }">
				<input type="hidden" name="perPageNum" value="${param.perPageNum }">
				<input type="hidden" name="key" value="${param.key }">
				<input type="hidden" name="word" value="${param.word }">
				
				<!-- Modal body -->
				<div class="modal-body">
					<!-- 내용 / 작성자 / 비밀번호 -->
					<div class="form-group" id="contentDiv">
						<label for="content">내용</label>
						<textarea class="form-control" rows="3" id="content" name="content"></textarea>
					</div>
					<div class="form-group" id="writerDiv">
						<label for="writer">작성자</label> 
						<input type="text" class="form-control" id="writer" name="writer">
					</div>
					<div class="form-group" id="pwDiv">
						<label for="pw">비밀번호</label> 
						<input type="password" class="form-control" id="pwd" name="pw">
					</div>
				</div>

				<!-- Modal footer -->
				<div class="modal-footer">
				<button class="btn btn-primary" id="replyModalWriteBtn" type="button">등록</button>    <!-- 0627 -->
				<button class="btn btn-success" id="replyModalUpdateBtn" type="button">수정</button> <!-- 0627 -->
				<button class="btn btn-danger" id="replyModalDeleteBtn" type="button">삭제</button>  <!-- 0627 -->
					<button type="button" class="btn btn-warning" data-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- 0627 -->
<script>
$(function () {
	
	//모달 화면
	
	//댓글 등록
	//replywriteBtn 아이디를 가진 요소가 클릭되면 이 함수가 실행
	$("#replywriteBtn").click(function () {
		// 모달 제목을 댓글 등록으로 설정
		$("#boardReplyModal").find(".modal-title").text("댓글등록") 
		//input / text를 선택한다
		// boardReplyForm 아이디를 가진 모든 input, textarea 찾아서 보이게 한다
		$("#boardReplyForm").find(".form-group").show();
		//data 지우기
		$("#boardReplyForm").find(".form-group>input, .form-group>textarea").val("");
		
		//버튼을 선택
		//먼저 버튼이 다 보이게
		$("#boardReplyForm button").show(); 
		//필요없는 버튼은 안보이게 한다
		//업데이트 버튼 삭제 버튼 삭제
		$("#replyModalUpdateBtn, #replyModalDeleteBtn").hide(); 
		//boardReplyModal 이란 아이디 가진 모달창 보이게 한다
		$("#boardReplyModal").modal("show"); 
	});

	//댓글 수정
	// 댓글 수정 버튼
	$(".replyUpdateBtn").click(function () {
		// 모달 제목을 
		//모달 제목을 댓글수정으로 설정
		$("#boardReplyModal").find(".modal-title").text("댓글수정") 
		//input / text를 선택한다 - 내용 / 작성자 / 비밀번호 
		// 눈에 안보이는 댓글 번호와 내용과 작성자 . 작성자를 데이터를 수집해서 value값으로 세팅해야 한다
		// // 가장 가까운 댓글 데이터 행을 선택
		//클릭된 수정 버튼(this)에서 가장 가까운 .replyDataRow 클래스를 가진 HTML 요소를 찾습니다
		let replyDataRow = $(this).closest(".replyDataRow");
		// data("rno") -> tag 안에 data-rno = 값
		// // 댓글의 고유 번호를 데이터 속성에서 추출
		//replyDataRow 요소에서 data-rno 속성의 값을 추출합니다. 이 값은 댓글의 고유 번호로, 데이터베이스에서 댓글을 구분할 때 사용됩니다.
		let rno = replyDataRow.data("rno");
		//replyDataRow 요소 내에서 .replyContent 클래스를 가진 요소의 텍스트(댓글 내용)와 
		let content = replyDataRow.find(".replyContent").text();
		//.replyWriter 클래스를 가진 요소의 텍스트(댓글 작성자)를 추출합니다.
		let writer = replyDataRow.find(".replyWriter").text();
		
		//data 지우기
		//#boardReplyForm 아이디를 가진 폼 내의 .form-group 클래스를 가진 요소들의 자식 input 및 textarea 요소들을 찾아 그 값을 빈 문자열로 설정합니다.
		$("#boardReplyForm").find(".form-group>input, .form-group>textarea").val("");
		
		// reply Modal  입력란에 세팅하기
		$("#rno").val(rno);
		$("#content").val(content);
		$("#writer").val(writer);
		$("#boardReplyForm").find(".form-group").show();
		// 버튼을 선택
		//  먼저 버튼이 다 보이게
		$("#boardReplyForm button").show();
		//  필요 없는 버튼은 안보이게 한다.
		$("#replyModalWriteBtn, #replyModalDeleteBtn").hide();
		
		$("#boardReplyModal").modal("show");
	});
	
	//댓글 삭제
	$(".replyDeleteBtn").click(function () {
		// 제목을 댓글 등옥
		$("#boardReplyModal").find(".modal-title").text("댓글삭제")
		//input / text를 선택한다
		let replyDataRow = $(this).closest(".replyDataRow");
		
		$("#boardReplyForm").find(".form-group").hide();
		$("#pwDiv").show();
		
		//data 지우기
		$("#boardReplyForm").find(".form-group>input, .form-group>textarea").val("");
		
		// data("rno") -> tag 안에 data-rno = 값
		$("#rno").val($(this).closest(".replyDataRow").data("rno"));
		
		//버튼을 선택
		//버튼이 다 보이게
		$("#boardReplyForm button").show(); 
		//필요없는 버튼은 안보이게 한다
		$("#replyModalUpdateBtn, #replyModalWriteBtn").hide(); 
		
		
		$("#boardReplyModal").modal("show");
	});
	
	//--------------Modal 화면 안의 처리 버튼 이벤트 처리 --------------------------
	$("#replyModalWriteBtn").click(function(){
			//데이터 전송해서 실행된ㄴ uri를 지정한다
			$("#boardReplyForm").attr("action", "/boardreply/write.do");
			//데이터를 전송하면서 페이지 이동을 시킨다 
			//다시 글보기 돌ㅇ
			$("#boardReplyForm").submit();
	});
	$("#replyModalUpdateBtn").click(function(){
		//데이터 전송해서 실행된ㄴ uri를 지정한다
		$("#boardReplyForm").attr("action", "/boardreply/update.do");
		//데이터를 전송하면서 페이지 이동을 시킨다 
		//다시 글보기 돌ㅇ
		$("#boardReplyForm").submit();
	});
	$("#replyModalDeleteBtn").click(function(){
			//데이터 전송해서 실행된ㄴ uri를 지정한다
			$("#boardReplyForm").attr("action", "/boardreply/delete.do");
			//데이터를 전송하면서 페이지 이동을 시킨다 
			//다시 글보기 돌ㅇ
			$("#boardReplyForm").submit();
	});
});
</script>