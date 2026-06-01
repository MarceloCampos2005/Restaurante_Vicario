<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String id_pedido = request.getParameter("PedidoSelecionado");
    if (id_pedido == null) {
        out.print("ERRO_NAO_AUTENTICADO");
        response.sendRedirect("pagelogin.jsp");
        return;
    }

    int pedidoId = -1;
    try {
        pedidoId = Integer.parseInt(id_pedido);
    } catch (NumberFormatException e) {
        out.print("ID do pedido inválido");
        return;
    }

    try {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }


        String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
        String user = "vicario";
        String password = "MarceloMoura123";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql2 = "DELETE FROM pedido_prato WHERE nr_pedido = ?";
            try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                stmt2.setInt(1, pedidoId);
                stmt2.executeUpdate();
            }
            String sql = "DELETE FROM pedido WHERE nr_pedido = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, pedidoId);
                stmt.executeUpdate();
            }

        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    String origem = request.getParameter("origem");
    if (origem == null || origem.isEmpty()) {
        origem = "index.jsp";
    }
    response.sendRedirect(origem);
%>
