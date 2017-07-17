<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%
	if(session.getAttribute("loginUserObj") != null ) {
	  response.sendRedirect("main-portal.action");
	} else {
	  response.sendRedirect("start-portal.action");
	}
%>