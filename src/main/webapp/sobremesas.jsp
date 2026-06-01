<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer id_email = (Integer) session.getAttribute("nomeUtilizador");
    boolean adm = false;
    boolean funcionario = false;

    String urldb = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String dbUser = "vicario";
    String dbPassword = "MarceloMoura123";
    if (id_email != null) {
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
    }
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Vicario</title>
    <link href="Css/style.css" rel="stylesheet">
    <!--Fonte de Letra-->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <!--Ícones-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
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
<form action="adicionar.jsp" class="adicionar" method="post">
    <div class="container">
        <h1 class="titulo">Sobremesas</h1>
        <input id="pratoSelecionado" name="pratoSelecionado" type="hidden">

        <div class="direita">
            <img alt="Mousse" src="images/maracuja.png">
            <div class="card-content">
                <h2>Mousse de Maracujá</h2>
                <p>Leve e refrescante, com o equilíbrio perfeito entre o<br> doce e o ácido do maracujá, servida com um
                    toque<br> tropical.</p>
                <p class="price">Preço: 6,00€</p>
                <input class="botao" onclick="selecionarPrato('mousse de maracuja')" type="submit" value="Adicionar ao pedido">
            </div>
        </div>

        <div class="esquerda">
            <img alt="Bolo_bolacha" src="images/bolacha.png">
            <div class="card-content">
                <h2>Bolo de Bolacha</h2>
                <p class="desc">Clássico e irresistível, com camadas de bolacha<br> embebidas em café e creme suave,
                    perfeito para os<br> amantes de tradição.</p>
                <p class="price">Preço: 6,50€</p>
                <input class="botao" onclick="selecionarPrato('bolo de bolacha')" type="submit" value="Adicionar ao pedido">
            </div>
        </div>

        <div class="direita">
            <img alt="leite_creme" src="images/leite_creme.png">
            <div class="card-content">
                <h2>Leite Creme</h2>
                <p>Sobremesa cremosa e delicada, com uma cobertura<br> crocante de caramelo queimado na perfeição.</p>
                <p class="price">Preço: 5,50€</p>
                <input class="botao" onclick="selecionarPrato('leite creme')" type="submit" value="Adicionar ao pedido">

            </div>
        </div>
        <input type="hidden" name="origem" value="sobremesas.jsp">

        <div class="esquerda">
            <img alt="Bolo_cenoura" src="images/cenoura_chocolate.png">
            <div class="card-content">
                <h2>Bolo de Cenoura com Chocolate</h2>
                <p class="desc">Um bolo húmido e aromático, coberto com uma<br> ganache de chocolate rica que derrete na
                    boca.</p>
                <p class="price">Preço: 7,00€</p>
                <input class="botao" onclick="selecionarPrato('bolo de cenoura com chocolate')" type="submit" value="Adicionar ao pedido">

            </div>
        </div>
    </div>
    <!-- Popup -->
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
            <p class="desc">O artigo selecionado foi adicionado ao<br>pedido!</p>
            <label class="close-btn" for="popupSucesso">Fechar</label>
        </div>
    </div>
</form>
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
<script src="js/adicionado.js"></script>
</body>
</html>