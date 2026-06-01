<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%
    Integer utilizador = (Integer) session.getAttribute("nomeUtilizador");
    String origem = request.getParameter("origem");

    if (utilizador == null) {
        request.setAttribute("popupStatus", "notLogged");
        RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
        dispatcher.forward(request, response);
        return;
    }

    double dose_final = 0;
    String dose = null;
    String prato = request.getParameter("pratoSelecionado");
    dose = request.getParameter("dose");

// Lista dos pratos que devem ter dose 1 ou -1
    List<String> pratosFixos = Arrays.asList(
            "pequena queijo e fiambre", "pequena pepperoni", "pequena 4 queijos", "pequena mozzarella",
            "tabua de enchidos artesanais", "canapes gourmet", "batatas recheadas gourmet", "croquetes recheados",
            "mousse de maracuja", "bolo de bolacha", "leite creme", "bolo de cenoura com chocolate",
            "vinho tinto", "vinho branco", "champanhe",
            "media queijo e fiambre", "media pepperoni", "media 4 queijos", "media mozzarella",
            "grande queijo e fiambre", "grande pepperoni", "grande 4 queijos", "grande mozzarella"
    );

    if (dose == null) {
        dose_final = 1;
    } else {
        switch (dose) {
            case "meia":
                dose_final = 0.5;
                break;
            case "-0.5":
                dose_final = -0.5;
                break;
            case "-1":
                dose_final = -1;
                break;
            case "pequena":
            case "media":
            case "grande":
                prato = dose + " " + prato;
                dose_final = 1;
                break;
            default:
                dose_final = 1;
                break;
        }
    }


    if (pratosFixos.contains(prato)) {
        if (dose != null && dose.equals("-0.5")) {
            dose_final = -1;
        } else {
            dose_final = 1;
        }
    }



    String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String user = "vicario";
    String password = "MarceloMoura123";

    try {
        Class.forName("org.mariadb.jdbc.Driver");

        // Conectar à base de dados
        try (Connection connect = DriverManager.getConnection(url, user, password)) {
            String sql1 = "SELECT id_carrinho FROM carrinho WHERE id_email = ?";
            try (PreparedStatement stmt1 = connect.prepareStatement(sql1)) {
                stmt1.setInt(1, utilizador);
                ResultSet rs1 = stmt1.executeQuery();
                if (rs1.next()) {
                    int id_carrinho = rs1.getInt("id_carrinho");
                    String sql = "SELECT id_tipo_prato FROM tipo_prato WHERE nome = ?";
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
                                String sql3 = "SELECT quantidade FROM carrinho_prato WHERE id_carrinho = ? and id_prato = ?";
                                try (PreparedStatement stmt3 = connect.prepareStatement(sql3)) {
                                    stmt3.setInt(1, id_carrinho);
                                    stmt3.setInt(2, id_tipo_prato);
                                    ResultSet rs3 = stmt3.executeQuery();
                                    if (rs3.next()) {
                                        double quantidade = rs3.getDouble("quantidade");
                                        if (quantidade == 1 && dose_final == -1 || quantidade == 0.5 && dose_final == -0.5) {
                                            String sql5 = "DELETE FROM carrinho_prato WHERE id_carrinho = ? and id_prato = ?";
                                            try (PreparedStatement stmt5 = connect.prepareStatement(sql5)) {
                                                stmt5.setInt(1, id_carrinho);
                                                stmt5.setInt(2, id_tipo_prato);
                                                stmt5.executeUpdate();
                                            }
                                        } else {

                                            String sql4 = "UPDATE carrinho_prato SET quantidade = ?, preco_venda = ? WHERE id_carrinho = ? and id_prato = ?";
                                            try (PreparedStatement stmt4 = connect.prepareStatement(sql4)) {
                                                dose_final += quantidade;
                                                stmt4.setDouble(1, dose_final);
                                                int arredondado = (int) Math.floor(dose_final);
                                                double preco_dose = 0.0;
                                                if (precos.size() > 1) {
                                                    // Garantir que o preço "1 dose" e "meia dose" existam
                                                    preco_dose = arredondado * precos.get(1);  // Preço da "1 dose"
                                                    double preco_meia = dose_final - arredondado;     // Preço da "meia dose"
                                                    if (preco_meia > 0) {
                                                        preco_dose += precos.get(0);  // Adiciona o preço da "meia dose" se houver
                                                    }
                                                    stmt4.setDouble(2, preco_dose);  // Atualiza o preço final
                                                } else if (precos.size() == 1) {
                                                    preco_dose = arredondado * precos.get(0);
                                                    stmt4.setDouble(2, preco_dose);
                                                } else {
                                                    out.println("<p>Erro: Nenhum preço encontrado.</p>");
                                                    return;
                                                }
                                                stmt4.setInt(3, id_carrinho);
                                                stmt4.setInt(4, id_tipo_prato);
                                                stmt4.executeUpdate();

                                            }
                                        }
                                    } else {
                                        String sql5 = "INSERT INTO carrinho_prato (id_carrinho, id_prato, quantidade, preco_venda) VALUES (?, ?, ?, ?)";
                                        try (PreparedStatement stmt5 = connect.prepareStatement(sql5)) {
                                            stmt5.setInt(1, id_carrinho);
                                            stmt5.setInt(2, id_tipo_prato);
                                            stmt5.setDouble(3, dose_final);
                                            if (dose_final == 0.5) {
                                                stmt5.setDouble(4, precos.get(0));
                                            } else if(precos.size() == 1){
                                                stmt5.setDouble(4, precos.get(0));
                                            } else {
                                                stmt5.setDouble(4, precos.get(1));
                                            }
                                            stmt5.executeUpdate();
                                        }
                                    }
                                    String sql6 = "UPDATE carrinho SET preco_tot = (SELECT SUM(preco_venda) FROM carrinho_prato WHERE id_carrinho = ?) WHERE id_carrinho = ?";
                                    try (PreparedStatement stmt6 = connect.prepareStatement(sql6)) {
                                        stmt6.setInt(1, id_carrinho);
                                        stmt6.setInt(2, id_carrinho);
                                        stmt6.executeUpdate();
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        // Caso haja erro ao conectar à base de dados
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }

    if (!Objects.equals(origem,"pedidotakeaway.jsp")){
        request.setAttribute("popupStatus", "success");
        RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
        dispatcher.forward(request, response);
    }else{
        RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
        dispatcher.forward(request, response);
    }
%>