<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="static java.lang.Double.sum" %>
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
    <title>Administração - Pedidos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="Css/admin.css">
</head>
<body>
<div class="admin-header d-flex justify-content-between align-items-center px-4">
    <h1 class="mb-0">Estatisticas do Restaurante</h1>
    <div>
        <a href="criticas.jsp" class="btn btn-success">Criticas do Restaurante</a>
        <a href="admin_pedidos.jsp" class="btn btn-success">Pedidos take-away</a>
        <a href="planta_restaurante.jsp" class="btn btn-success">Planta do Restaurante</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="container mt-5 mb-5 d-flex justify-content-center">
    <div class="grafico-container">
        <canvas id="graficoPratos"></canvas>
    </div>
</div>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    StringBuilder labels1 = new StringBuilder();
    StringBuilder data1 = new StringBuilder();
    StringBuilder labels2 = new StringBuilder();
    StringBuilder data2 = new StringBuilder();


    String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String user = "vicario";
    String password = "MarceloMoura123";
    double soma = 0.0;

    try {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            try (Connection connect = DriverManager.getConnection(url, user, password)) {
                String sql1 = "SELECT nome, nr_doses FROM prato_estatistica";
                try (PreparedStatement stmt1 = connect.prepareStatement(sql1)) {
                    ResultSet rs1 = stmt1.executeQuery();
                    while (rs1.next()) {
                        labels1.append("'").append(rs1.getString("nome")).append("',");
                        data1.append(rs1.getDouble("nr_doses")).append(",");
                    }
                }
                String sql2 = "SELECT faturamento FROM faturamento_pedido";
                try (PreparedStatement stmt2 = connect.prepareStatement(sql2)) {
                    ResultSet rs2 = stmt2.executeQuery();
                    while (rs2.next()) {
                        labels2.append("'").append("Take-away").append("',");
                        data2.append(rs2.getDouble("faturamento")).append(",");
                    }
                }
                String sql3 = "SELECT faturamento FROM faturamento_mesa";
                try (PreparedStatement stmt3 = connect.prepareStatement(sql3)) {
                    ResultSet rs3 = stmt3.executeQuery();
                    while (rs3.next()) {
                        labels2.append("'").append("Ás mesas").append("',");
                        data2.append(rs3.getDouble("faturamento")).append(",");
                    }
                }
                String[] partes = data2.toString().split(",");

                for (String parte : partes) {
                    soma += Double.parseDouble(parte);
                }
            }
        } catch (ClassNotFoundException e) {
            out.println("Erro: " + e.getMessage());
        }
    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    }
%>
<script>
    const ctxPratos = document.getElementById('graficoPratos').getContext('2d');
    new Chart(ctxPratos, {
        type: 'bar',
        data: {
            labels: [<%= labels1.toString().replaceAll(",$", "") %>],
            datasets: [{
                label: 'Unidades Vendidas',
                data: [<%= data1.toString().replaceAll(",$", "") %>],
                backgroundColor: '#2ecc71',
                borderRadius: 8,
                barThickness: 40
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Quantidade de Unidades Vendidas',
                    font: {
                        size: 20
                    }
                },
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 20
                    }
                }
            }
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<div class="container mt-5 mb-5 d-flex justify-content-left">
    <div class="grafico-faturamento">
        <canvas id="graficoFaturamento" width="300" height="300" style="display: block;"></canvas>
    </div>
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-12 col-md-10 col-lg-8">
                <div class="card shadow-lg border-0 rounded-4 text-center py-5 px-3 bg-light">
                    <div class="card-body">
                        <h2 class="fw-semibold text-secondary">Faturamento Total</h2>
                        <p class="display-3 fw-bold text-primary mt-3">
                            <%= String.format("%.2f", soma) %> €
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
<script>
    const ctxFaturamento = document.getElementById('graficoFaturamento').getContext('2d');
    new Chart(ctxFaturamento, {
        type: 'pie',
        data: {
            labels: [<%= labels2.toString().replaceAll(",$", "") %>],
            datasets: [{
                data: [<%= data2.toString().replaceAll(",$", "") %>],
                backgroundColor: ['#f39c12', '#2980b9']
            }]
        },
        options: {
            plugins: {
                title: { display: true, text: 'Faturamento Total' }
            }
        }
    });
</script>
</body>
</html>

