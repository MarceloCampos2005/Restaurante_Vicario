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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vicario</title>
    <link rel="stylesheet" href="Css/style.css">
    <!--Fonte de Letra-->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <!--Ícones-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

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
        <h1 class="titulo">Carnes</h1>
        <input id="pratoSelecionado" name="pratoSelecionado" type="hidden">

        <div class="direita">
            <img src="images/Picanha.png" alt="picanha">
            <div class="card-content">
                <h2>Picanha</h2>
                <p>Corte nobre e suculento, servido no ponto ideal para<br> destacar o sabor único, com um toque de tradição<br> portuguesa.</p>
                <p class="price">Meia Dose: 17,00€<br>1 Dose: 28,00€</p>
                <label class="botao" for="popup2" onclick="selecionarPrato('picanha') ">Adicionar ao pedido</label>
            </div>
        </div>

        <div class="esquerda">
            <img src="images/maturado.png" alt="Costeletão">
            <div class="card-content">
                <h2>Costeletão maturado</h2>
                <p class="desc">Carne premium, maturada para intensificar o sabor e<br> garantir uma textura inigualável, ideal para ocasiões<br> especiais.</p>
                <p class="price">Meia Dose: 25,00€<br>1 Dose: 45,00€</p>
                <label class="botao" for="popup2" onclick="selecionarPrato('costeletao') ">Adicionar ao pedido</label>
            </div>
        </div>

        <div class="direita">
            <img src="images/entrecosto.png" alt="entrecosto">
            <div class="card-content">
                <h2>Entrecosto</h2>
                <p>Carne macia e caramelizada na perfeição, com um<br> equilíbrio entre textura e sabor intenso, ideal para<br> amantes de grelhados.</p>
                <p class="price">Meia Dose: 15,00€<br>1 Dose: 25,00€</p>
                <label class="botao" for="popup2" onclick="selecionarPrato('entrecosto') ">Adicionar ao pedido</label>
            </div>
        </div>
        <input type="hidden" name="origem" value="carnes.jsp">

        <div class="esquerda">
            <img src="images/fraldinha.png" alt="fraldinha">
            <div class="card-content">
                <h2>Fraldinha</h2>
                <p class="desc">Corte clássico e tenro, conhecido pelo seu sabor<br> marcante e pela textura única, perfeito para uma<br> experiência autêntica.</p>
                <p class="price">Meia Dose: 16,00€<br>1 Dose: 27,00€</p>
                <label class="botao" for="popup2" onclick="selecionarPrato('fraldinha') ">Adicionar ao pedido</label>
            </div>
        </div>
    </div>
    <!-- Popup -->

    <input class="popup-checkbox" id="popup2" type="checkbox">
    <div class="popup-overlay">
        <div class="popup-content">
            <p class="negrito">Selecione a quantidade:</p>
            <p class="cimabaixo">
                <input id="dose" name="dose" type="hidden">
                <input class="dose" onclick="selecionarDose('meia')" type="submit" value="Meia Dose">
                <input class="dose" onclick="selecionarDose('1')" type="submit" value="1 Dose">
            </p>
            <label class="close-btn" for="popup2">Fechar</label>
        </div>
    </div>

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