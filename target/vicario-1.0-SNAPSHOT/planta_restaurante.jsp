<%@ page import="java.sql.*" %>
<%
    Integer id_email = (Integer) session.getAttribute("nomeUtilizador");
    boolean adm = false;
    boolean funcionario = false;

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
            String sql = "SELECT COUNT(*) FROM administrador WHERE id_email = ?";
            String sql2 = "SELECT COUNT(*) FROM funcionario WHERE id_email = ?";

            try (PreparedStatement stmt = connect.prepareStatement(sql);
                 PreparedStatement stmt2 = connect.prepareStatement(sql2)) {

                stmt.setInt(1, id_email);
                stmt2.setInt(1, id_email);

                try (ResultSet rs = stmt.executeQuery();
                     ResultSet rs2 = stmt2.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {
                        adm = true;
                    }

                    if (rs2.next() && rs2.getInt(1) > 0) {
                        funcionario = true;
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }

    // Verificação de acesso
    if (!adm && !funcionario) {
        out.println("<p style='color:red;'>Acesso negado.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Planta do Restaurante</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            padding: 40px;
        }

        .voltar-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #555;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
        }

        .voltar-btn:hover {
            background: #333;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        .planta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .mesa {
            background: #fff;
            border: 2px solid #333;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            min-width: 180px;
        }

        .mesa h2 {
            margin: 0 0 10px;
        }

        .cadeiras {
            display: flex;
            justify-content: space-around;
            margin-top: 10px;
        }

        .cadeira {
            width: 20px;
            height: 20px;
            background: #999;
            border-radius: 50%;
        }

        .mesa.ocupada {
            background-color: #ffd6d6;
            border-color: #ff4d4d;
        }

        .mesa.livre {
            background-color: #d6ffd6;
            border-color: #4dff4d;
        }

        .botao-pedido {
            margin-top: 10px;
            padding: 8px 12px;
            background: #000;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .botao-pedido:hover {
            background: #333;
        }
    </style>
</head>
<body>
<%
    if (adm) {
%>
<a href="admin_pedidos.jsp" class="voltar-btn">Voltar</a>
<%
    } else {
%>
<a href="index.jsp" class="voltar-btn">Voltar</a>
<%
    }
%>
<h1>Planta do Restaurante</h1>

<div class="planta">
    <%
        String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
        String user = "vicario";
        String password = "MarceloMoura123";

        try {
            try {
                Class.forName("org.mariadb.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sqlPedidos = "SELECT count(*) FROM mesa_prato where id_mesa = ?";
                String tipo = "";
                try (PreparedStatement stmtCarrinhos = conn.prepareStatement(sqlPedidos)) {
                    for (int i = 1; i <= 20; i++) {
                        stmtCarrinhos.setInt(1, i);
                        try (ResultSet rsCarrinhos = stmtCarrinhos.executeQuery()) {
                            if (rsCarrinhos.next()) {
                                int quantidade = rsCarrinhos.getInt(1);
                                if (quantidade > 0){
                                    tipo = "ocupada";
                                } else {
                                    tipo = "livre";
                                }
                        }

    %>
    <div class="mesa <%=tipo%>" id="mesa<%= i %>">
        <h2>Mesa <%= i %></h2>
        <div class="cadeiras">
            <div class="cadeira"></div>
            <div class="cadeira"></div>
        </div>
        <button class="botao-pedido" onclick="fazerPedido(<%= i %>)">Fazer Pedido</button>
        <button class="botao-pedido" onclick="Pago(<%= i %>)">Pagar Pedido</button>
    </div>
    <%                  }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
</div>

<script>
    function fazerPedido(numeroMesa) {
        window.location.href = 'registarPedido.jsp?mesa=' + numeroMesa;
    }
    function Pago(numeroMesa) {
        window.location.href = 'verPedido.jsp?mesa=' + numeroMesa;
    }
</script>
</body>
</html>
