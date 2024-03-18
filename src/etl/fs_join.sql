CREATE TABLE fs_join AS

    SELECT 
          t1.dtReference,
          t1.seller_id,
          t1.qntPedidos,
          t1.qtdDias,
          t1.qntItens,
          t1.qtdRecencia,
          t1.ticketMedio,
          t1.avgValorProduto,
          t1.maxValorProduto,
          t1.minValorProduto,
          t1.avgProdutoPedido,
          t1.minVlPedido,
          t1.maxVlPedido,
          t1.LTV,
          t1.qtdeDiasBase,
          t1.avgIntervaloVendas,
          
          t2.avgReview,
          --t2.medianNota,
          t2.minReview,
          t2.maxReview,
          t2.pctReview,
          
          t3.qtdUFsPedidos,
          t3.pctPedidoAC,
          t3.pctPedidoAL,
          t3.pctPedidoAM,
          t3.pctPedidoAP,
          t3.pctPedidoBA,
          t3.pctPedidoCE,
          t3.pctPedidoDF,
          t3.pctPedidoES,
          t3.pctPedidoGO,
          t3.pctPedidoMA,
          t3.pctPedidoMG,
          t3.pctPedidoMS,
          t3.pctPedidoMT,
          t3.pctPedidoPA,
          t3.pctPedidoPB,
          t3.pctPedidoPE,
          t3.pctPedidoPI,
          t3.pctPedidoPR,
          t3.pctPedidoRJ,
          t3.pctPedidoRN,
          t3.pctPedidoRO,
          t3.pctPedidoRR,
          t3.pctPedidoRS,
          t3.pctPedidoSC,
          t3.pctPedidoSE,
          t3.pctPedidoSP,
          t3.pctPedidoTO,

          t4.pctPedidoAtraso,
          t4.pctPedidoCancelado,
          t4.avgFrete,
          t4.maxFrete,
          t4.minFrete,
          t4.qtdDiasAprovadoxEntrega,
          t4.qtdDiasPedidoEntrega,
          t4.qtdDiasEntregaxPromessa,

          t5.qtdeboleto_pedido,
          t5.qtdecredit_card_pedido,
          t5.qtdevoucher_pedido,
          t5.qtdedebit_card_pedido,
          t5.valor_boleto_pedido,
          t5.valor_credit_card_pedido,
          t5.valor_voucher_pedido,
          t5.valor_debit_card_pedido,
          t5.pct_qtd_boleto_pedido,
          t5.pct_qtd_credit_card_pedido,
          t5.pct_qtd_voucher_pedido,
          t5.pct_qtd_debit_card_pedido,
          t5.pct_valor_boleto_pedido,
          t5.pct_valor_credit_card_pedido,
          t5.pct_valor_voucher_pedido,
          t5.pct_valor_debit_card_pedido,
          t5.avgQtdeParcelas,
          --t5.medianQtdeParcelas,
          t5.maxQtdeParcelas,
          t5.minQtdeParcelas,
          
          t6.avgFotos,
          t6.avgProduct_vol,
          --t6.medianVolumeProduto,
          t6.minVolProduct,
          t6.maxVolProduct,
          t6.pctCategoriacama_mesa_banho,
          t6.pctCategoriabeleza_saude,
          t6.pctCategoriaesporte_lazer,
          t6.pctCategoriainformatica_acessorios,
          t6.pctCategoriamoveis_decoracao,
          t6.pctCategoriautilidades_domesticas,
          t6.pctCategoriarelogios_presentes,
          t6.pctCategoriatelefonia,
          t6.pctCategoriaautomotivo,
          t6.pctCategoriabrinquedos,
          t6.pctCategoriacool_stuff,
          t6.pctCategoriaferramentas_jardim,
          t6.pctCategoriaperfumaria,
          t6.pctCategoriabebes,
          t6.pctCategoriapapelaria

    FROM fs_vendedor_vendas AS t1

    LEFT JOIN fs_vendedor_avaliacao AS t2
    ON t1.seller_id = t2.seller_id
    AND t1.dtReference = t2.dtReference

    LEFT JOIN fs_vendedor_clientes AS t3
    ON t1.seller_id = t3.seller_id
    AND t1.dtReference = t3.dtReference

    LEFT JOIN fs_vendedor_entregas AS t4
    ON t1.seller_id = t4.seller_id
    AND t1.dtReference = t4.dtReference

    LEFT JOIN fs_vendedor_pagamentos AS t5
    ON t1.seller_id = t5.seller_id
    AND t1.dtReference = t5.dtReference

    LEFT JOIN fs_vendedor_produtos AS t6
    ON t1.seller_id = t6.seller_id
    AND t1.dtReference = t6.dtReference

    WHERE t1.dtReference = (select max(dtReference) from fs_vendedor_vendas)