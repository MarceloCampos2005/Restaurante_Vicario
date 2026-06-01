<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    Integer id_email = (Integer) session.getAttribute("nomeUtilizador");

    if (id_email == null) {
        response.sendRedirect("pagelogin.jsp");
        return;
    }

    String urldb = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String dbUser = "vicario";
    String dbPassword = "MarceloMoura123";

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        try (Connection connect = DriverManager.getConnection(urldb, dbUser, dbPassword)) {
            String sql = "SELECT * FROM administrador WHERE id_email = ?";
            try (PreparedStatement stmt = connect.prepareStatement(sql)) {
                stmt.setInt(1, id_email);
                ResultSet rs = stmt.executeQuery();

                if (!rs.next()) {
                    out.println("<p style='color:red;'>Acesso negado: você não é administrador.</p>");
                    return;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Administração - Criticas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="Css/admin.css">
</head>
<body>
<div class="admin-header d-flex justify-content-between align-items-center px-4">
    <h1 class="mb-0">Criticas dos Clientes</h1>
    <div>
        <a href="admin_pedidos.jsp" class="btn btn-success">Pedidos Take-away</a>
        <a href="estatisticas_restaurante.jsp" class="btn btn-success">Estatisticas do Restaurante</a>
        <a href="planta_restaurante.jsp" class="btn btn-success">Planta do Restaurante</a>
    </div>
</div>

<div class="container mt-4">
    <div class="accordion" id="accordionPedidos">
        <%
            String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
            String user = "vicario";
            String password = "MarceloMoura123";

            int contador = 1;
            try {
                try {
                    Class.forName("org.mariadb.jdbc.Driver");
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
                try (Connection conn = DriverManager.getConnection(url, user, password)) {

                    String sqlPedidos = "SELECT * FROM critica";
                    try (PreparedStatement stmtCarrinhos = conn.prepareStatement(sqlPedidos);
                         ResultSet rsPedidos = stmtCarrinhos.executeQuery()) {

                        while (rsPedidos.next()) {
                            String email = "";
                            String assunto = rsPedidos.getString("assunto");
                            String mensagem = rsPedidos.getString("mensagem");
                            String data_hora = rsPedidos.getString("data_hora");
                            int id_email1 = rsPedidos.getInt("id_email");
                            String sql2 = "SELECT email FROM utilizador where id_email = ?";
                            try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                                stmt2.setInt(1, id_email1);
                                ResultSet rs = stmt2.executeQuery();
                                if (rs.next()){
                                    email = rs.getString("email");
                                }

        %>
        <div class="accordion-item">
            <h2 class="accordion-header" id="heading<%=contador%>">
                <button class="accordion-button collapsed" type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#collapse<%=contador%>"
                        aria-expanded="false"
                        aria-controls="collapse<%=contador%>">
                    Crítica <%=contador%>
                </button>
            </h2>
            <div id="collapse<%=contador%>" class="accordion-collapse collapse"
                 aria-labelledby="heading<%=contador%>"
                 data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <strong>Assunto:</strong> <%=assunto%><br>
                    <strong>Mensagem:</strong> <%=mensagem%><br>
                    <strong>Data:</strong> <%=data_hora%><br>
                    <strong>Email:</strong> <%=email%>
                </div>
            </div>
        </div>


        <%
                            contador++;
                        }
                    }
                }
            }
            } catch (Exception e) {
                out.println("<p class='text-danger'>Erro ao carregar pedidos: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }

        %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
