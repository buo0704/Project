package com.webjjang.member.service;

import com.webjjang.main.dao.DAO;
import com.webjjang.main.service.Service;
import com.webjjang.member.dao.MemberDAO;

public class MemberConUpdateService implements Service {

	@Override
	public Integer service(Object obj) throws Exception {
		// DB 처리는 DAO에서 처리 - MemberDAO.updateConDate() : obj == id
	   // MemberController - (Execute) - [MemberListService] - MemberDAO.view()
        return new MemberDAO().updateConDate((String)obj);
	}
	@Override
	public void setDAO(DAO dao) {
		
	}
}
