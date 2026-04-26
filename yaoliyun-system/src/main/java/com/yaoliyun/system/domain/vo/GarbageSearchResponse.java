package com.yaoliyun.system.domain.vo;

import java.util.List;

/**
 * 垃圾分类查询响应VO
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageSearchResponse
{
    /** 状态码 */
    private Integer code;

    /** 错误信息 */
    private String msg;

    /** 返回结果集 */
    private Result result;

    public Integer getCode()
    {
        return code;
    }

    public void setCode(Integer code)
    {
        this.code = code;
    }

    public String getMsg()
    {
        return msg;
    }

    public void setMsg(String msg)
    {
        this.msg = msg;
    }

    public Result getResult()
    {
        return result;
    }

    public void setResult(Result result)
    {
        this.result = result;
    }

    /**
     * 结果集
     */
    public static class Result
    {
        /** 查询结果列表 */
        private List<GarbageInfo> list;

        /** 总数 */
        private Integer total;

        public List<GarbageInfo> getList()
        {
            return list;
        }

        public void setList(List<GarbageInfo> list)
        {
            this.list = list;
        }

        public Integer getTotal()
        {
            return total;
        }

        public void setTotal(Integer total)
        {
            this.total = total;
        }
    }

    /**
     * 垃圾分类信息
     */
    public static class GarbageInfo
    {
        /** 废弃物名称 */
        private String name;

        /** 垃圾分类，0为可回收、1为有害、2为厨余(湿)、3为其他(干) */
        private Integer type;

        /** 垃圾分类名称（前端展示用） */
        private String typeName;

        /** 投放提示 */
        private String tip;

        /** 智能预判，0为正常结果，1为预判结果 */
        private Integer aipre;

        /** 包含类型 */
        private String contain;

        /** 分类解释 */
        private String explain;

        public String getName()
        {
            return name;
        }

        public void setName(String name)
        {
            this.name = name;
        }

        public Integer getType()
        {
            return type;
        }

        public void setType(Integer type)
        {
            this.type = type;
        }

        public String getTypeName()
        {
            return typeName;
        }

        public void setTypeName(String typeName)
        {
            this.typeName = typeName;
        }

        public String getTip()
        {
            return tip;
        }

        public void setTip(String tip)
        {
            this.tip = tip;
        }

        public Integer getAipre()
        {
            return aipre;
        }

        public void setAipre(Integer aipre)
        {
            this.aipre = aipre;
        }

        public String getContain()
        {
            return contain;
        }

        public void setContain(String contain)
        {
            this.contain = contain;
        }

        public String getExplain()
        {
            return explain;
        }

        public void setExplain(String explain)
        {
            this.explain = explain;
        }
    }
}
