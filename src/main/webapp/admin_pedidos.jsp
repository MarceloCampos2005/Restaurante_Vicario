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
  <title>Administração - Pedidos</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="Css/admin.css">
</head>
<body>
<div class="admin-header d-flex justify-content-between align-items-center px-4">
  <h1 class="mb-0">Pedidos Take-away</h1>
  <div>
    <a href="criticas.jsp" class="btn btn-success">Criticas do Restaurante</a>
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
        Class.forName("org.mariadb.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(url, user, password)) {

          String sqlPedidos = "SELECT nr_pedido FROM pedido";
          try (PreparedStatement stmtCarrinhos = conn.prepareStatement(sqlPedidos);
               ResultSet rsPedidos = stmtCarrinhos.executeQuery()) {

            while (rsPedidos.next()) {
              int id_pedido = rsPedidos.getInt("nr_pedido");
    %>
    <form id="formRetirarPedido" action="retirarpedido.jsp" method="post">
    <div class="accordion-item">
      <h2 class="accordion-header" id="heading<%=contador%>">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=contador%>" aria-expanded="false" aria-controls="collapse<%=contador%>">
          Pedido <%=contador%>
        </button>
      </h2>
      <div id="collapse<%=contador%>" class="accordion-collapse collapse" aria-labelledby="heading<%=contador%>" data-bs-parent="#accordionPedidos">
        <div class="accordion-body">
          <table class="table table-bordered table-hover">
            <thead class="table-light">
            <tr>
              <th>Prato</th>
              <th>Quantidade</th>
              <th>Preço (€)</th>
            </tr>
            </thead>
            <tbody>
            <%
              String sqlDetalhes = "SELECT tp.nome, cp.quantidade, cp.preco_venda " +
                      "FROM pedido_prato cp " +
                      "JOIN tipo_prato tp ON cp.id_prato = tp.id_tipo_prato " +
                      "WHERE cp.nr_pedido = ?";
              try (PreparedStatement stmtDetalhes = conn.prepareStatement(sqlDetalhes)) {
                stmtDetalhes.setInt(1, id_pedido);
                try (ResultSet rsDetalhes = stmtDetalhes.executeQuery()) {
                  while (rsDetalhes.next()) {
            %>
            <tr>
              <td><%= rsDetalhes.getString("nome") %></td>
              <td><%= rsDetalhes.getDouble("quantidade") %></td>
              <td><%= String.format("%.2f", rsDetalhes.getDouble("preco_venda")) %></td>
            </tr>
            <%
                  }
                }
              }
            %>
            </tbody>
          </table>
          <input id="PedidoSelecionado" name="PedidoSelecionado" type="hidden">
          <input type="hidden" name="origem" value="admin_pedidos.jsp">
          <button type="button" class="button_retirarpedido" onclick="selecionarPedido('<%= id_pedido %>')">Retirar Pedido</button>
        </div>
      </div>
    </div>
    </form>



    <%
              contador++;
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
<script src="js/nrpedido.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>