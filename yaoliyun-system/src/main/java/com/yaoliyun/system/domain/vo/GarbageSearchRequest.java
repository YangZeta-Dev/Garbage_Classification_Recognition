package com.yaoliyun.system.domain.vo;

/**
 * 垃圾分类查询请求VO
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageSearchRequest
{
    /** 废弃物名称 */
    private String word;

    /** 返回数量 */
    private Integer num;

    /** 查询模式，0模糊查询[默认]、1精确查询 */
    private Integer mode;

    /** 翻页 */
    private Integer page;

    public String getWord()
    {
        return word;
    }

    public void setWord(String word)
    {
        this.word = word;
    }

    public Integer getNum()
    {
        return num;
    }

    public void setNum(Integer num)
    {
        this.num = num;
    }

    public Integer getMode()
    {
        return mode;
    }

    public void setMode(Integer mode)
    {
        this.mode = mode;
    }

    public Integer getPage()
    {
        return page;
    }

    public void setPage(Integer page)
    {
        this.page = page;
    }
}
