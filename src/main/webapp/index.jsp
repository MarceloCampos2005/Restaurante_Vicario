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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
<section class="image-container">
        <img src="images/restaurante.jpg" alt="Imagem do Restaurante" class="restaurante">
    </section>

    <div class="categorias-container">
        <h1>Categorias</h1>
        <div class="categorias">
            <div class="categoria">
                <a href="massas.jsp"><img src="images/massas.png" alt="Massas"></a>
                <h2>Massas</h2>
                <p>Explore as nossas massas, preparadas com ingredientes de qualidade para uma experiência de sabor incomparável.</p>
            </div>
            <div class="categoria">
                <a href="pizzas.jsp"><img src="images/pizzas.png" alt="Pizzas"></a>
                <h2>Pizzas</h2>
                <p>Descubra a variedade das nossas pizzas, feitas com os melhores ingredientes para uma experiência única de sabor.</p>
            </div>
            <div class="categoria">
                <a href="carnes.jsp"><img src="images/carnes.png" alt="Carnes"></a>
                <h2>Carnes</h2>
                <p>Descubra o sabor das nossas carnes, preparadas com cortes e ingredientes de qualidade para uma experiência única.</p>
            </div>
        </div>
        <div class="categorias">
            <div class="categoria">
                <a href="entradas.jsp"><img src="images/entradas.png" alt="Entradas"></a>
                <h2>Entradas</h2>
                <p>Aprecie as nossas entradas quentes, preparadas com ingredientes selecionados para um sabor irresistível.</p>
            </div>
            <div class="categoria">
                <a href="sobremesas.jsp"><img src="images/sobremesas.png" alt="Sobremesas"></a>
                <h2>Sobremesas</h2>
                <p>Finalize a sua refeição com nossas sobremesas, feitas com toques especiais para um doce e inesquecível momento de prazer.</p>
            </div>
            <div class="categoria">
                <a href="bebidas.jsp"><img src="images/bebidas.png" alt="Bebidas"></a>
                <h2>Bebidas</h2>
                <p>Descubra as nossas bebidas, feitas com ingredientes selecionados para uma experiência refrescante.</p>
            </div>
        </div>
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
</body>
</html>