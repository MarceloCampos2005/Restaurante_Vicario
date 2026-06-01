<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>
<%
    Integer nome = (Integer) session.getAttribute("nomeUtilizador");
    String origem = request.getParameter("origem");
    if (nome == null) {
        request.setAttribute("popupStatus", "notLogged");
        RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
        dispatcher.forward(request, response);
        return;
    }

    String assunto = request.getParameter("assunto");
    String mensagem = request.getParameter("mensagem");


    String URL = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String dbUsername = "vicario";
    String dbPassword = "MarceloMoura123";

    Connection con = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection(URL, dbUsername, dbPassword);

        String sql = "INSERT INTO critica (assunto, mensagem, id_email) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, assunto);
        ps.setString(2, mensagem);
        ps.setInt(3, nome);

        ps.executeUpdate();



    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Erro: " + e.getMessage() + "</p>");
    }

    request.setAttribute("popupStatus", "success");
    RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
    dispatcher.forward(request, response);

%>
