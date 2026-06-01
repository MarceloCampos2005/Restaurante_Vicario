<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String mesa = request.getParameter("mesa");
    if (mesa == null) mesa = "não definida";

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
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Registar Pedido - Mesa <%= mesa %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px;
            font-family: Arial, sans-serif;
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

        .titulo {
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: bold;
        }

        .categoria-buttons {
            text-align: center;
            margin-bottom: 20px;
        }

        .categoria-buttons button {
            margin: 5px;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            background-color: #343a40;
            color: white;
            cursor: pointer;
        }

        .categoria-buttons button:hover {
            background-color: #495057;
        }

        .pratos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }

        .prato-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            text-align: center;
            padding-bottom: 15px;
        }

        .prato-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .prato-nome {
            font-size: 18px;
            font-weight: bold;
            padding: 10px 0;
        }

        .dose-buttons form {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin: 0 20px;
        }
    </style>
</head>
<body>
<a href="planta_restaurante.jsp" class="voltar-btn">Voltar</a>

<div class="titulo">Mesa <%= mesa %> - Escolha os pratos</div>

<div class="categoria-buttons">
    <button onclick="filtrarCategoria('Massas')">Massas</button>
    <button onclick="filtrarCategoria('Pizzas')">Pizzas</button>
    <button onclick="filtrarCategoria('Carne')">Carne</button>
    <button onclick="filtrarCategoria('Entradas')">Entradas</button>
    <button onclick="filtrarCategoria('Sobremesas')">Sobremesas</button>
    <button onclick="filtrarCategoria('Bebidas')">Bebidas</button>
</div>

<div class="pratos-grid" id="grid">
    <%
        String[][] pratos = {
                // nome, imagem, categoria
                {"carbonara", "images/carbonara.png", "Massas"},
                {"bolonhesa", "images/bolonhesa.png", "Massas"},
                {"camaroes", "images/camaroes.png", "Massas"},
                {"atum", "images/atum.png", "Massas"},
                {"picanha", "images/Picanha.png", "Carne"},
                {"costeletao", "images/maturado.png", "Carne"},
                {"entrecosto", "images/entrecosto.png", "Carne"},
                {"fraldinha", "images/fraldinha.png", "Carne"},

                {"queijo e fiambre", "images/queijo_fiambre.png", "Pizzas"},
                {"pepperoni", "images/peperoni.png", "Pizzas"},
                {"4 queijos", "images/queijos4.png", "Pizzas"},
                {"mozzarella", "images/mozzarela.png", "Pizzas"},

                {"tabua de enchidos artesanais", "images/tabuaenchidos.png", "Entradas"},
                {"canapes gourmet", "images/canape.png", "Entradas"},
                {"batatas recheadas gourmet", "images/batatarecheada.png", "Entradas"},
                {"croquetes recheados", "images/croquetes.png", "Entradas"},

                {"mousse de maracuja", "images/maracuja.png", "Sobremesas"},
                {"bolo de bolacha", "images/bolacha.png", "Sobremesas"},
                {"leite creme", "images/leite_creme.png", "Sobremesas"},
                {"bolo de cenoura com chocolate", "images/cenoura_chocolate.png", "Sobremesas"},

                {"vinho tinto", "images/tinto.png", "Bebidas"},
                {"vinho branco", "images/branco.png", "Bebidas"},
                {"champanhe", "images/champanhe.png", "Bebidas"},
                {"agua", "images/agua.png", "Bebidas"},
        };

        for (int i = 0; i < pratos.length; i++) {
            String nome = pratos[i][0];
            String imagem = pratos[i][1];
            String categoria = pratos[i][2];
    %>
    <div class="prato-card" data-categoria="<%= categoria %>">
        <img src="<%= imagem %>" alt="<%= nome %>">
        <div class="prato-nome"><%= nome %></div>
        <div class="dose-buttons">
            <form action="guardarPedido.jsp" method="post">
                <input type="hidden" name="origem" value="registarPedido.jsp?mesa=<%= mesa %>">
                <input type="hidden" name="mesa" value="<%= mesa %>">
                <input type="hidden" name="prato" value="<%= nome %>">
                <input type="hidden" name="porcao" id="porcao<%=i%>" value="">
                <div class="mb-2">
                    <% if (Objects.equals(categoria, "Pizzas")) { %>
                    <select name="porcao" class="form-select" onchange="document.getElementById('porcao<%=i%>').value=this.value;" required>
                        <option value="">Selecionar Porção</option>
                        <option value="Pequena">Pequena</option>
                        <option value="Media">Media</option>
                        <option value="Grande">Grande</option>
                    </select>
                    <% } %>
                </div>
                <select name="dose" class="form-control mb-2" required>
                    <option value="">Selecionar Dose</option>
                    <%
                        if (categoria.equals("Massas") || categoria.equals("Carne") || nome.equals("agua")) {
                            for (double d = 0.5; d <= 10; d += 0.5) {
                    %>
                    <option value="<%= d %>"><%= d %></option>
                    <%
                            }
                        } else {
                            for (double d = 1; d <= 10; d += 1) {
                    %>
                    <option value="<%= d %>"><%= d %></option>
                    <%
                            }
                        }
                    %>
                </select>
                <button type="submit" class="btn btn-dark">Adicionar</button>
            </form>
        </div>
    </div>
    <% } %>

</div>
<script>
    function filtrarCategoria(categoria) {
        const cards = document.querySelectorAll('.prato-card');
        cards.forEach(card => {
            if (card.dataset.categoria === categoria) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
