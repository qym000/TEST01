/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-21
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-21
 */
package com.mingyoutech.mybi.demo.coding.core.template.procedure;

import com.mingyoutech.mybi.demo.coding.core.builder.AbstractTemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter.Type;
import com.mingyoutech.mybi.demo.coding.core.util.TextUtil;

/**
 * 存储过程模板
 * @author John Xi, 2016-3-21
 */
public class ProcedureBuilder extends AbstractTemplateBuilder implements ItemplateBuilder {
  
  /**
   * 脚本整体缩进几个空格
   * <li>默认0缩进，一般为偶数</li>
   */
  @Parameter(type = Type.Integer, value = "0")
  public static final String RETRACT = "retract";
  
  /**
   * 存储过程名称
   * <li>存储过程名称默认为P_DEMO</li>
   */
  @Parameter(type = Type.String, value = "P_DEMO")
  public static final String NAME = "name";
  
  /**
   * 作者
   * <li>作者默认为MY</li>
   */
  @Parameter(type = Type.String, value = "MY")
  public static final String AUTHOR = "author";
  
  /**
   * 每行脚本的缩进
   */
  private String retract = "";

  @Override
  public String getCodingTemplate(Object obj) throws Exception {
    
    StringBuffer buffer = new StringBuffer();
    
    retract = findRetract();
    String procedureName = ((String) getParm(NAME)).toUpperCase();
    
    buffer.append(format("CREATE OR REPLACE PROCEDURE " + procedureName + "(ic_cendat varchar2, ic_jobid varchar2, ic_seq varchar2) IS"));
    
    
    
     
    
     
     
    
    
    
    
     
    
    
    
    
    
    
    
    
    buffer.append(format("/************************************************************************"));
    buffer.append(format(" *      文 件 名  : "));
    buffer.append(format(" *      程 序 名  : "));
    buffer.append(format(" *      功能描述: "));
    buffer.append(format(" *"));
    buffer.append(format(" *      入口参数:"));
    buffer.append(format(" *        ic_cendat   varchar2       数据日期"));
    buffer.append(format(" *        ic_jobid    varchar2       作业ID"));
    buffer.append(format(" *        ic_seq      varchar2       执行序号（MYETL随机生成）"));
    buffer.append(format(" *      出口参数："));
    buffer.append(format(" *"));
    buffer.append(format(" *      创建者　：" + getParm(AUTHOR)));
    buffer.append(format(" *      创建日期：" + TextUtil.getStringDate()));
    buffer.append(format(" *      版本号　：1.0"));
    buffer.append(format(" *      修改历史："));
    buffer.append(format(" *      ===== ============= ========================================"));
    buffer.append(format(" *       姓名    日 期                     描 述"));
    buffer.append(format(" *      ===== ============= ========================================"));
    buffer.append(format(" *      " + getParm(AUTHOR) + "    " + TextUtil.getStringDate() + "    创建程序。"));
    buffer.append(format("**************************************************************************/"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format(" v_info varchar2(200);  -- 用于存储日志信息"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format("BEGIN"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format("  -- 记录日志"));
    buffer.append(format("  v_info := '程序开始运行';"));
    buffer.append(format("  myetl_write_logger(ic_cendat, ic_jobid, ic_seq, v_info);"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format("  -- 加工逻辑"));
    buffer.append(format("  null;"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format("  -- 程序完成，记录成功状态"));
    buffer.append(format("  myetl_write_suc(ic_cendat, ic_jobid, ic_seq);"));
    buffer.append(TextUtil.lineSeparator());
    buffer.append(format("EXCEPTION"));
    buffer.append(format("  WHEN OTHERS THEN"));
    buffer.append(format("    -- 发生未知异常，记录错误状态"));
    buffer.append(format("    myetl_write_err(ic_cendat, ic_jobid, ic_seq, substr(sqlerrm, 1, 200));"));
    buffer.append(format("    ROLLBACK;"));
    buffer.append(format("END " + procedureName + ";"));
        
    return buffer.toString();
  }

  /**
   * 为每一行代码追加格式：前缩进，后换行
   * @param message 传入的代码
   * @return 追加过格式的代码
   */
  private String format(String message) {
    return TextUtil.lineSeparator(retract + message);
  }

  /**
   * 生成缩进样式（其实就是若干个空格）
   * @return 需要缩进的空格
   */
  private String findRetract() {
    
    StringBuffer buffer = new StringBuffer();
    
    for (int i = 0; i < (Integer) getParm(RETRACT); i++) {
      buffer.append(" ");
    }
    
    return buffer.toString();
  }




}
