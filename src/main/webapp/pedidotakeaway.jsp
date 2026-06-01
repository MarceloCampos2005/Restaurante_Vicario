<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vicario</title>
    <link rel="stylesheet" href="Css/style.css">
    <!--Fonte de Letra-->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <!--Ícones-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <%
        String popupStatus = (String) request.getAttribute("popupStatus");
    %>
</head>
<body>
<header>
    <h1><a href="index.jsp" class="title">Vicario</a></h1>
    <nav class="nav_em">
        <%
            if (adm) {
        %>
        <a href="estatisticas_restaurante.jsp" class="admin-btn">Admin</a>
        <%
        } else if (funcionario) {
        %>
        <a href="planta_restaurante.jsp" class="funcionario-btn">Funcionário</a>
        <%
            }
        %>
        <div class="dropdown">
            <a class="dropbtn">Ementas ▼</a>
            <div class="dropdown-content">
                <a href="massas.jsp">Massas</a>
                <a href="pizzas.jsp">Pizzas</a>
                <a href="carnes.jsp">Carnes</a>
                <a href="entradas.jsp">Entradas</a>
                <a href="sobremesas.jsp">Sobremesas</a>
                <a href="bebidas.jsp">Bebidas</a>
            </div>
        </div>
        <a href="about.jsp">Sobre Nós</a>
        <a href="pedidotakeaway.jsp"><i class="fa fa-shopping-cart icon"></i></a>
        <a href="perfil.jsp"><i class="fa fa-user-o icon_em"></i></a>
    </nav>
</header>
<div data-layer="Sobre Nós" class="text_take_away">
    Faça o seu pedido<br>Takeaway
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
                        String sqlCarrinhos = "SELECT id_carrinho, preco_tot FROM carrinho WHERE id_email = ?";
                        try (PreparedStatement stmtCarrinhos = conn.prepareStatement(sqlCarrinhos)) {
                            stmtCarrinhos.setInt(1, id_email);
                            try (ResultSet rsCarrinhos = stmtCarrinhos.executeQuery()) {
                                while (rsCarrinhos.next()) {
                                    int id_carrinho = rsCarrinhos.getInt("id_carrinho");
                                    preco_total = rsCarrinhos.getDouble("preco_tot");
                                    String sqlDetalhes = "SELECT tp.nome, cp.quantidade, cp.preco_venda " +
                                            "FROM carrinho_prato cp " +
                                            "JOIN tipo_prato tp ON cp.id_prato = tp.id_tipo_prato " +
                                            "WHERE cp.id_carrinho = ?";
                                    try (PreparedStatement stmtDetalhes = conn.prepareStatement(sqlDetalhes)) {
                                        stmtDetalhes.setInt(1, id_carrinho);
                                        try (ResultSet rsDetalhes = stmtDetalhes.executeQuery()) {
                                            while (rsDetalhes.next()) {
                                                String nome = rsDetalhes.getString("nome");
                                                double quantidade = rsDetalhes.getDouble("quantidade");
                                                double preco_venda = rsDetalhes.getDouble("preco_venda");
                                                if (quantidade > 0) {

                                                %>
            <form action="adicionar.jsp" class="adicionar" method="post">
                <input id="pratoSelecionado" name="pratoSelecionado" type="hidden">
                <input type="hidden" id="dose" name="dose">
                <input type="hidden" name="origem" value="pedidotakeaway.jsp">
                <nav class="line2">
                    <div class="left">
                        <p><%= nome %></p>
                    </div>
                    <div class="center">
                        <input class="btn minus" onclick="selecionarDose('-0.5'); selecionarPrato('<%=nome%>')" type="submit" value="-">
                        <p><%= quantidade %></p>
                        <input class="btn plus" onclick="selecionarDose('meia'); selecionarPrato('<%=nome%>')" type="submit" value="+">
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
            </form>
        </div>
        <form action="Adicionarpedido.jsp" class="adicionar" method="post">
            <input type="hidden" name="origem" value="pedidotakeaway.jsp">
            <input class="botao-finalizar" type="submit" value="Finalizar Pedido">
            <input type="checkbox" id="popupErro" class="popup-checkbox" <% if ("notLogged".equals(popupStatus)) { %>checked<% } %> />
            <div class="popup-overlay">
                <div class="popup-content">
                    <p class="negrito">Aviso</p>
                    <p class="desc">Para poder realizar um pedido Takeaway, é<br>necessário ter uma conta iniciada!</p>
                    <label class="close-btn" for="popupErro">Fechar</label>
                </div>
            </div>

            <input type="checkbox" id="popupSucesso" class="popup-checkbox" <% if ("success".equals(popupStatus)) { %>checked<% } %> />
            <div class="popup-overlay">
                <div class="popup-content">
                    <p class="negrito">Sucesso</p>
                    <p class="desc">O pedido foi realizado com sucesso!</p>
                    <label class="close-btn" for="popupSucesso">Fechar</label>
                </div>
            </div>

            <input type="checkbox" id="popupNopratos" class="popup-checkbox" <% if ("notPlates".equals(popupStatus)) { %>checked<% } %> />
            <div class="popup-overlay">
                <div class="popup-content">
                    <p class="negrito">Aviso</p>
                    <p class="desc">Nenhum prato selecionado!</p>
                    <label class="close-btn" for="popupNopratos">Fechar</label>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- Popup -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-section">
            <h3>Vicario</h3>
            <div class="social-icon">
                <a href="https://www.instagram.com/instagram/" target="_blank"><i class="fa fa-instagram"></i></a>
                <a href="https://www.facebook.com/Cristiano?locale=ms_MY" target="_blank"><i class="fa fa-facebook"></i></a>
            </div>
        </div>
        <div class="footer-section">
            <h3>Categorias</h3>
            <div class="categories-grid">
                <ul class="categories-column">
                    <li><a href="massas.jsp">Massas</a></li>
                    <li><a href="pizzas.jsp">Pizzas</a></li>
                    <li><a href="carnes.jsp">Carnes</a></li>
                </ul>
                <ul class="categories-column">
                    <li><a href="entradas.jsp">Entradas</a></li>
                    <li><a href="sobremesas.jsp">Sobremesas</a></li>
                    <li><a href="bebidas.jsp">Bebidas</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-section">
            <h3>Localização e Contacto</h3>
            <p>Rua das Flores, Porto</p>
            <p>224838743</p>
        </div>
    </div>
</footer>
<script src="js/adicionarprato.js"></script>
</body>
</html>