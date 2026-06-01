<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpSession" %>
<%
  HttpSession sessao = request.getSession(false);
  if (sessao != null) {
    sessao.invalidate();
  }
  response.sendRedirect("pagelogin.jsp");
%>

