// 패키지 선언
package com.webjjang.main.controller;

// 필요한 클래스들을 임포트합니다.
import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.webjjang.board.controller.BoardController;
import com.webjjang.boardreply.controller.BoardReplyController;
import com.webjjang.image.controller.ImageController;
import com.webjjang.member.controller.MemberController;

/**
 * Servlet implementation class DispatcherServlet
 */
// Servlet 애너테이션이 주석 처리되어 있습니다. 보통은 이 애너테이션을 사용하거나 web.xml에서 직접 서블릿을 등록합니다.
//@WebServlet(urlPatterns = "*.do", loadOnStartup = 1)
public class DispatcherServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	// BoardController 인스턴스를 생성합니다. 이 컨트롤러는 게시판 요청을 처리합니다.
	private BoardController boardController = new BoardController();
	private BoardReplyController boardReplyController = new BoardReplyController();
	private MemberController memberController = new MemberController();
	private ImageController imageController = new ImageController();

	// 서블릿 초기화 메서드. 서블릿이 처음 생성될 때 호출됩니다.
	public void init(ServletConfig config) throws ServletException {
		System.out.println("dispatcherServlet.init ----  초기화");
		// Init 클래스를 로드하여 초기화 로직을 수행합니다.
		try {
			// 객체 생성과 초기화 + 조립
			Class.forName("com.webjjang.main.controller.Init");
			// -- 오라클 드라이버 확인 + 로딩
			Class.forName("com.webjjang.util.db.DB");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	/**
	 * service 메서드는 모든 HTTP 요청(GET, POST 등)을 처리합니다.
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("DispatcherServlet.service");

		// 요청 URI를 가져옵니다.
		String uri = request.getRequestURI();
		System.out.println("uri = " + uri);
		// URI에서 두 번째 "/"의 위치를 찾습니다.
		int pos = uri.indexOf("/", 1);
		System.out.println("pos = " + pos);

		// 두 번째 "/"가 없다면 404 에러 페이지를 보여줍니다.
		if (pos == -1) {
			request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
			return;
		}

		// 모듈 이름을 추출합니다. (예: /board)
		String module = uri.substring(0, pos);
		System.out.println("module = " + module);

		// requestd 에 module 담아서 어떤 메뉴가 선택되었는지 처리 : default_decorator.jsp 0628
		request.setAttribute("module", module);

		String jsp = null;

		// URI에 따라 적절한 컨트롤러를 실행합니다.
		switch (module) {
		case "/board":
			System.out.println("일반게시판");
			jsp = boardController.execute(request);
			break;

		case "/boardreply":
			System.out.println("일반게시판 댓글");
			jsp = boardReplyController.execute(request);
			break;
			
		case "/member":
			System.out.println("회원관리");
			jsp = memberController.execute(request);
			break;
			
		case"/image":
			System.out.println("이미지");
			jsp = imageController.execute(request);
			break;

		default:
			request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
			return;
		}

		// 요청에 대한 응답으로 JSP 페이지를 보여줍니다.
		// jsp 정보 앞에 redirect:이 붙어 있으면 redirect 시킨다 (페이지 자동 이동 )
		// jsp 정보 앞에 redirect:이 붙어 있지 않으면 jsp로 foward시킨다
		if (jsp.indexOf("redirect:") == 0) {
			// redirect: list.do -> uri로 사용하기 위해 redirect은 잘라버린다
			response.sendRedirect(jsp.substring("redirect:".length()));
		} else {
			// 그렇지 않으면 foward시킨다
			// jsp로 forward한다
			request.getRequestDispatcher("/WEB-INF/views/" + jsp + ".jsp").forward(request, response);
			// request.getSession().removeAttribute("msg");
		}
	}

	/**
	 * doGet 메서드는 HTTP GET 요청을 처리합니다.
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

}
