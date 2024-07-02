package com.webjjang.boardreply.service;

import java.util.List;

import com.webjjang.boardreply.dao.BoardReplyDAO;
import com.webjjang.boardreply.vo.BoardReplyVO;
import com.webjjang.main.dao.DAO;
import com.webjjang.main.service.Service;
import com.webjjang.util.page.ReplyPageObject;

public class BoardReplyListService implements Service {
	

	private BoardReplyDAO dao; //240625
	
	//dao setter 240625
	public void setDAO(DAO dao) {
		this.dao = (BoardReplyDAO) dao;
	}
	
	@Override
	public List<BoardReplyVO> service(Object obj) throws Exception {
		
		// BoardDAO dao = new BoardDAO();
		ReplyPageObject pageObject = (ReplyPageObject) obj;
		// DB board_Reply에서 리스트 쿼리 실행해서 데이터 가져오기 - 리턴
		//전체 데이터의 개수
		pageObject.setTotalRow(dao.getTotalRow(pageObject));
		
		// DB 처리는 DAO에서 처리 - BoardReplyDAO.list()
		// BoardController - (Execute) - [BoardReplyListService] - BoardReplyDAO.list()
		return dao.list(pageObject);		
	}
}