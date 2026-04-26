package com.yaoliyun.system.domain.vo;

import java.util.List;

/**
 * 垃圾识别响应VO
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageRecognitionResponse
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
        /** 识别结果列表 */
        private List<GarbageItem> list;

        public List<GarbageItem> getList()
        {
            return list;
        }

        public void setList(List<GarbageItem> list)
        {
            this.list = list;
        }
    }

    /**
     * 垃圾识别项
     */
    public static class GarbageItem
    {
        /** 识别物体名称 */
        private String name;

        /** 可信度，单位百分比 */
        private Integer trust;

        /** 垃圾分类提示 */
        private String lajitip;

        /** 垃圾分类，0为可回收、1为有害、2为厨余(湿)、3为其他(干)、4为未知结果 */
        private Integer lajitype;

        /** 垃圾分类名称（前端展示用） */
        private String lajitypeName;

        public String getName()
        {
            return name;
        }

        public void setName(String name)
        {
            this.name = name;
        }

        public Integer getTrust()
        {
            return trust;
        }

        public void setTrust(Integer trust)
        {
            this.trust = trust;
        }

        public String getLajitip()
        {
            return lajitip;
        }

        public void setLajitip(String lajitip)
        {
            this.lajitip = lajitip;
        }

        public Integer getLajitype()
        {
            return lajitype;
        }

        public void setLajitype(Integer lajitype)
        {
            this.lajitype = lajitype;
        }

        public String getLajitypeName()
        {
            return lajitypeName;
        }

        public void setLajitypeName(String lajitypeName)
        {
            this.lajitypeName = lajitypeName;
        }
    }
}
