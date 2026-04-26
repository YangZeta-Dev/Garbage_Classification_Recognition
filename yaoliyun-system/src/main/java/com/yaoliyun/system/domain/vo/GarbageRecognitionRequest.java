package com.yaoliyun.system.domain.vo;

/**
 * 垃圾识别请求VO
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageRecognitionRequest
{
    /** 图片base64编码，与imgurl参数二选一 */
    private String img;

    /** 图片URL地址（支持jpg/png/bmp格式） */
    private String imgurl;

    /** 0或空为严格模式，1为模糊模式 */
    private Integer mode;

    /** 识别来源（1拍照 2相册） */
    private String source;

    public String getImg()
    {
        return img;
    }

    public void setImg(String img)
    {
        this.img = img;
    }

    public String getImgurl()
    {
        return imgurl;
    }

    public void setImgurl(String imgurl)
    {
        this.imgurl = imgurl;
    }

    public Integer getMode()
    {
        return mode;
    }

    public void setMode(Integer mode)
    {
        this.mode = mode;
    }

    public String getSource()
    {
        return source;
    }

    public void setSource(String source)
    {
        this.source = source;
    }
}
