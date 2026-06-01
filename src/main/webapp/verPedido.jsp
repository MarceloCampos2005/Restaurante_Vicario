<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String mesa = request.getParameter("mesa");
    if (mesa == null) {
        out.print("ERRO_NAO_AUTENTICADO");
        response.sendRedirect("planta_restaurante.jsp");
        return;
    }

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
            String sql = "SELECT COUNT(*) FROM administrador WHERE id_email = ?";
            String sql2 = "SELECT COUNT(*) FROM funcionario WHERE id_email = ?";
            try (PreparedStatement stmt = connect.prepareStatement(sql); PreparedStatement stmt2 = connect.prepareStatement(sql2)) {
                stmt.setInt(1, id_email);
                stmt2.setInt(1, id_email);
                ResultSet rs = stmt.executeQuery();
                ResultSet rs2 = stmt2.executeQuery();

                if (!rs.next() || !rs2.next()) {
                    out.println("<p style='color:red;'>Acesso negado.</p>");
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
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vicario</title>

    <!-- Estilos -->
    <link rel="stylesheet" href="Css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            padding: 30px;
            background-color: #f9f9f9;
        }

        .voltar-btn {
            display: inline-block;
            margin-bottom: 30px;
            padding: 12px 24px;
            background-color: #343a40;
            color: #fff;
            text-decoration: none;
            border-radius: 10px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .voltar-btn:hover {
            background-color: #212529;
        }

        .pedido-info {
            text-align: center;
            font-size: 24px;
            font-weight: 700;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<a href="planta_restaurante.jsp" class="voltar-btn"><i class="fa fa-arrow-left"></i> Voltar</a>

<div class="pedido-info">
    Pedido da Mesa <%= mesa %>
</div>
<div class="take_away_box">
    <div class="content_take_away_box">
        <div id="carrinhoContainer">
            <nav class="line">
                <div class="left">
                    <p>Nome</p>
                </div>
                <div class="center">
                    <p>Quantidade</p>
                </div>
                <div class="right">
                    <p>Preço</p>
                </div>
            </nav>
            <%
                String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
                String user = "vicario";
                String password = "MarceloMoura123";

                double preco_total = 0;
                try {
                    try {
                        Class.forName("org.mariadb.jdbc.Driver");
                    } catch (ClassNotFoundException e) {
                        throw new RuntimeException(e);
                    }
                    try (Connection conn = DriverManager.getConnection(url, user, password)) {
                        String sqlMesa = "SELECT id_mesa, preco_tot FROM mesa WHERE numero_mesa = ?";
                        try (PreparedStatement stmtMesa = conn.prepareStatement(sqlMesa)) {
                            stmtMesa.setString(1, mesa);
                            try (ResultSet rsMesa = stmtMesa.executeQuery()) {
                                while (rsMesa.next()) {
                                    int id_mesa = rsMesa.getInt("id_mesa");
                                    preco_total = rsMesa.getDouble("preco_tot");
                                    String sqlDetalhes = "SELECT tp.nome, cp.quantidade, cp.preco_venda " +
                                            "FROM mesa_prato cp " +
                                            "JOIN tipo_prato tp ON cp.id_prato = tp.id_tipo_prato " +
                                            "WHERE cp.id_mesa = ?";
                                    try (PreparedStatement stmtDetalhes = conn.prepareStatement(sqlDetalhes)) {
                                        stmtDetalhes.setInt(1, id_mesa);
                                        try (ResultSet rsDetalhes = stmtDetalhes.executeQuery()) {
                                            while (rsDetalhes.next()) {
                                                String nome = rsDetalhes.getString("nome");
                                                double quantidade = rsDetalhes.getDouble("quantidade");
                                                double preco_venda = rsDetalhes.getDouble("preco_venda");
                                                if (quantidade > 0) {

            %>
            <nav class="line2">
                <div class="left">
                    <p><%= nome %></p>
                </div>
                <div class="center">
                    <p><%= quantidade %></p>
                </div>
                <div class="right">
                    <p><%= preco_venda %>€</p>
                </div>
            </nav>
                <%
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                %>
            <nav class="line2">
                <div class="right">
                    <p class="negrito2">Preço total:</p>
                    <p><%= preco_total %></p>
                </div>
            </nav>
        </div>
        <form action="pagarPedido.jsp" class="adicionar" method="post">
            <input type="hidden" name="mesa" value="<%= mesa %>">
            <input type="hidden" name="origem" value="verPedido.jsp">
            <input class="botao-finalizar" type="submit" value="Pagar Pedido">
        </form>
    </div>
</div>
<!-- Popup -->
<input type="checkbox" id="popup" class="popup-checkbox">
<div class="popup-overlay">
    <div class="popup-content">
        <p class="negrito">Sucesso</p>
        <p class="desc">Pago com sucesso!</p>
        <label for="popup" class="close-btn">Fechar</label>
    </div>
</div>
</body>
</html>
