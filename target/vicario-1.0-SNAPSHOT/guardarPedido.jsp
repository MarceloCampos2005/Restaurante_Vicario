<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    String mesatemp = request.getParameter("mesa");
    if (mesatemp == null) {
        out.print("ERRO_NAO_AUTENTICADO");
        response.sendRedirect("registarPedido.jsp");
        return;
    }
    int mesa = Integer.parseInt(mesatemp);

    String prato = request.getParameter("prato");
    String porcao = request.getParameter("porcao");
    String temp = request.getParameter("dose");
    double dose = 0.0;
    try {
        dose = Double.parseDouble(temp);
    } catch (NumberFormatException e) {
        dose = 0.0;
    }
    if (porcao != null && !porcao.isEmpty()) {
        prato = porcao + " " + prato;
    }

    try {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
        String user = "vicario";
        String password = "MarceloMoura123";

        try (Connection connect = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT id_tipo_prato FROM tipo_prato WHERE nome=?";
            try (PreparedStatement stmt = connect.prepareStatement(sql)) {
                stmt.setString(1, prato);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int id_tipo_prato = rs.getInt("id_tipo_prato");
                    String sql2 = "SELECT preco_atual FROM preco WHERE nome_prato = ? order by id_preco";
                    try (PreparedStatement stmt2 = connect.prepareStatement(sql2)) {
                        stmt2.setString(1, prato);
                        ResultSet rs2 = stmt2.executeQuery();
                        List<Double> precos = new ArrayList<>();
                        double preco = 0;
                        while (rs2.next()) {
                            preco = rs2.getDouble("preco_atual");
                            precos.add(preco);
                        }
                        String sql3 = "SELECT quantidade FROM mesa_prato WHERE id_mesa = ? and id_prato = ?";
                        try (PreparedStatement stmt3 = connect.prepareStatement(sql3)) {
                            stmt3.setInt(1, mesa);
                            stmt3.setInt(2, id_tipo_prato);
                            ResultSet rs3 = stmt3.executeQuery();
                            if (rs3.next()) {
                                double quantidade = rs3.getDouble("quantidade");
                                String sql4 = "UPDATE mesa_prato SET quantidade = ?, preco_venda = ? WHERE id_mesa = ? and id_prato = ?";
                                try (PreparedStatement stmt4 = connect.prepareStatement(sql4)) {
                                    dose += quantidade;
                                    stmt4.setDouble(1, dose);
                                    int arredondado = (int) Math.floor(dose);
                                    double preco_dose = 0.0;
                                    if (precos.size() > 1) {
                                        preco_dose = arredondado * precos.get(1);
                                        double preco_meia = dose - arredondado;
                                        if (preco_meia > 0) {
                                            preco_dose += precos.get(0);
                                        }
                                        stmt4.setDouble(2, preco_dose);
                                    } else if (precos.size() == 1) {
                                        preco_dose = arredondado * precos.get(0);
                                        stmt4.setDouble(2, preco_dose);
                                    } else {
                                        out.println("<p>Erro: Nenhum preço encontrado.</p>");
                                        return;
                                    }
                                    stmt4.setInt(3, mesa);
                                    stmt4.setInt(4, id_tipo_prato);
                                    stmt4.executeUpdate();

                                }
                            } else {
                                String sql5 = "INSERT INTO mesa_prato (id_mesa, id_prato, quantidade, preco_venda) VALUES (?, ?, ?, ?)";
                                try (PreparedStatement stmt5 = connect.prepareStatement(sql5)) {
                                    stmt5.setInt(1, mesa);
                                    stmt5.setInt(2, id_tipo_prato);
                                    stmt5.setDouble(3, dose);
                                    int arredondado = (int) Math.floor(dose);
                                    double preco_dose = 0.0;
                                    if (precos.size() > 1) {
                                        // Garantir que o preço "1 dose" e "meia dose" existam
                                        preco_dose = arredondado * precos.get(1);  // Preço da "1 dose"
                                        double preco_meia = dose - arredondado;     // Preço da "meia dose"
                                        if (preco_meia > 0) {
                                            preco_dose += precos.get(0);  // Adiciona o preço da "meia dose" se houver
                                        }
                                        stmt5.setDouble(4, preco_dose);  // Atualiza o preço final
                                    } else if (precos.size() == 1) {
                                        preco_dose = arredondado * precos.get(0);
                                        stmt5.setDouble(4, preco_dose);
                                    } else {
                                        out.println("<p>Erro: Nenhum preço encontrado.</p>");
                                        return;
                                    }
                                    stmt5.executeUpdate();
                                }
                            }
                            String sql6 = "UPDATE mesa SET preco_tot = (SELECT SUM(preco_venda) FROM mesa_prato WHERE id_mesa = ?) WHERE id_mesa = ?";
                            try (PreparedStatement stmt6 = connect.prepareStatement(sql6)) {
                                stmt6.setInt(1, mesa);
                                stmt6.setInt(2, mesa);
                                stmt6.executeUpdate();
                            }
                        }
                    }
                }
            }
        }
    }catch (Exception e) {
        // Caso haja erro ao conectar à base de dados
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }

    String origem = request.getParameter("origem");
    if (origem == null || origem.isEmpty()) {
        origem = "index.jsp";
    }
    response.sendRedirect(origem);
%>

