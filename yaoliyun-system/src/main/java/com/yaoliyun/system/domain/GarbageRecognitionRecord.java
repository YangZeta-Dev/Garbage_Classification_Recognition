package com.yaoliyun.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;

/**
 * 垃圾识别记录对象 garbage_recognition_record
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageRecognitionRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 用户ID关联字段（关联sys_user表） */
    private String nickName;

    /** 原图URL */
    @Excel(name = "原图URL")
    private String imageUrl;

    /** 缩略图URL */
    @Excel(name = "缩略图URL")
    private String thumbnailUrl;

    /** 识别到的物品ID */
    @Excel(name = "识别到的物品ID")
    private Long recognizedItemId;

    /** 识别结果名称 */
    @Excel(name = "识别结果名称")
    private String recognizedName;

    /** 分类ID */
    @Excel(name = "分类ID")
    private Long categoryId;

    /** 分类ID关联字段（关联garbage_category表） */
    private String categoryName;

    /** 置信度（0-100） */
    @Excel(name = "置信度", readConverterExp = "0=-100")
    private BigDecimal confidenceScore;

    /** 获得积分 */
    @Excel(name = "获得积分")
    private Long pointsEarned;

    /** 识别来源（1拍照 2相册） */
    @Excel(name = "识别来源", readConverterExp = "1=拍照,2=相册")
    private String recognitionSource;

    /** 识别时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "识别时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date recognitionTime;

    /** 删除标志（0存在 2删除） */
    private String delFlag;

    public void setRecordId(Long recordId) 
    {
        this.recordId = recordId;
    }

    public Long getRecordId() 
    {
        return recordId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setNickName(String nickName) 
    {
        this.nickName = nickName;
    }

    public String getNickName() 
    {
        return nickName;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) 
    {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getThumbnailUrl() 
    {
        return thumbnailUrl;
    }

    public void setRecognizedItemId(Long recognizedItemId) 
    {
        this.recognizedItemId = recognizedItemId;
    }

    public Long getRecognizedItemId() 
    {
        return recognizedItemId;
    }

    public void setRecognizedName(String recognizedName) 
    {
        this.recognizedName = recognizedName;
    }

    public String getRecognizedName() 
    {
        return recognizedName;
    }

    public void setCategoryId(Long categoryId) 
    {
        this.categoryId = categoryId;
    }

    public Long getCategoryId() 
    {
        return categoryId;
    }

    public void setCategoryName(String categoryName) 
    {
        this.categoryName = categoryName;
    }

    public String getCategoryName() 
    {
        return categoryName;
    }

    public void setConfidenceScore(BigDecimal confidenceScore) 
    {
        this.confidenceScore = confidenceScore;
    }

    public BigDecimal getConfidenceScore() 
    {
        return confidenceScore;
    }

    public void setPointsEarned(Long pointsEarned) 
    {
        this.pointsEarned = pointsEarned;
    }

    public Long getPointsEarned() 
    {
        return pointsEarned;
    }

    public void setRecognitionSource(String recognitionSource) 
    {
        this.recognitionSource = recognitionSource;
    }

    public String getRecognitionSource() 
    {
        return recognitionSource;
    }

    public void setRecognitionTime(Date recognitionTime) 
    {
        this.recognitionTime = recognitionTime;
    }

    public Date getRecognitionTime() 
    {
        return recognitionTime;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("recordId", getRecordId())
            .append("userId", getUserId())
            .append("imageUrl", getImageUrl())
            .append("thumbnailUrl", getThumbnailUrl())
            .append("recognizedItemId", getRecognizedItemId())
            .append("recognizedName", getRecognizedName())
            .append("categoryId", getCategoryId())
            .append("confidenceScore", getConfidenceScore())
            .append("pointsEarned", getPointsEarned())
            .append("recognitionSource", getRecognitionSource())
            .append("recognitionTime", getRecognitionTime())
            .append("delFlag", getDelFlag())
            .append("createTime", getCreateTime())
            .toString();
    }
}
