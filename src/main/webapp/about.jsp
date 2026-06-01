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
<div class="containerabout">
    <section class="sobre-nos">
        <div class="texto">
            <h1>Sobre Nós</h1>
            <p class="descricao">Gastronomia sofisticada, sabores autênticos e uma experiência única em cada prato.</p>
            <p class="paragrafo">
                Bem-vindo ao Vicario, um espaço sofisticado onde a gastronomia encontra-se com a elegância. No nosso restaurante, oferecemos uma experiência única com pratos preparados com ingredientes de qualidade superior e um toque moderno. O menu é uma verdadeira celebração de sabores, desde cortes de carne premium até sobremesas irresistíveis.<br>
                A nossa carta de vinhos foi cuidadosamente selecionada para harmonizar perfeitamente com os pratos, e o ambiente acolhedor e atento ao detalhe proporciona o cenário ideal para qualquer ocasião especial. No Vicario, cada refeição é uma memória inesquecível.
            </p>
            <h2>Contacte-nos</h2>
            <form class="formulario" action="aboutbackend.jsp" method="post">
                <input type="hidden" name="origem" value="about.jsp">
                <div class="campo-unico" id="utilizador-wrapper">
                    <div class="invalid-feedback" id="erro_utilizador"></div>
                    <div class="valid-feedback" id="enviado"></div>
                    <label for="assunto">Assunto</label>
                    <input class="iptnomes" type="text" id="assunto" name="assunto" required>
                </div>
                <div class="campo-unico">
                    <label for="mensagem">Escreva aqui a sua mensagem</label>
                    <textarea class="iptmensagem" id="mensagem" name="mensagem" rows="10" required></textarea>
                </div>
                <div class="campo-unico">
                    <button type="submit" class="botao-enviar">Enviar</button>
                </div>
                <input type="checkbox" id="popupSucesso" class="popup-checkbox" <% if ("success".equals(popupStatus)) { %>checked<% } %> />
                <div class="popup-overlay">
                    <div class="popup-content">
                        <p class="negrito">Sucesso</p>
                        <p class="desc">A sua crítica foi realizada com sucesso!</p>
                        <label class="close-btn" for="popupSucesso">Fechar</label>
                    </div>
                </div>
                <input type="checkbox" id="popupErro" class="popup-checkbox" <% if ("notLogged".equals(popupStatus)) { %>checked<% } %> />
                <div class="popup-overlay">
                    <div class="popup-content">
                        <p class="negrito">Aviso</p>
                        <p class="desc">Para poder fazer uma critica, é necessário ter uma conta iniciada!</p>
                        <label class="close-btn" for="popupErro">Fechar</label>
                    </div>
                </div>
            </form>
        </div>
        <div class="imagem">
            <img src="images/restaurante.jpg" alt="Imagem de um restaurante">
        </div>
    </section>
</div>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="js/formulario.js"></script>
</body>
</html>
