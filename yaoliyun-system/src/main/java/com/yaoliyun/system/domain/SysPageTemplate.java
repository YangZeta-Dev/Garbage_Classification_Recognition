package com.yaoliyun.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;

/**
 * 页面模板管理对象 sys_page_template
 * 
 * @author yaoliyun
 * @date 2025-01-26
 */
public class SysPageTemplate extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 模板ID */
    private Long templateId;

    /** 模板名称 */
    @Excel(name = "模板名称")
    private String templateName;

    /** 模板类型（index首页 list列表 detail详情 form表单 login登录 user用户中心） */
    @Excel(name = "模板类型", readConverterExp = "index=首页,list=列表,detail=详情,form=表单,login=登录,user=用户中心")
    private String templateType;

    /** 模板描述 */
    @Excel(name = "模板描述")
    private String templateDescription;

    /** 预览图片路径 */
    @Excel(name = "预览图片路径")
    private String previewImage;

    /** 模板代码（源代码） */
    private String templateCode;

    /** 分类（ecommerce电商 social社交 tool工具 common通用） */
    @Excel(name = "分类", readConverterExp = "ecommerce=电商,social=社交,tool=工具,common=通用")
    private String category;

    /** 标签（逗号分隔） */
    @Excel(name = "标签")
    private String tags;

    /** 下载使用次数 */
    @Excel(name = "下载使用次数")
    private Integer downloadCount;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 排序（数字越小越靠前） */
    @Excel(name = "排序")
    private Integer sortOrder;

    public void setTemplateId(Long templateId) 
    {
        this.templateId = templateId;
    }

    public Long getTemplateId() 
    {
        return templateId;
    }
    public void setTemplateName(String templateName) 
    {
        this.templateName = templateName;
    }

    public String getTemplateName() 
    {
        return templateName;
    }
    public void setTemplateType(String templateType) 
    {
        this.templateType = templateType;
    }

    public String getTemplateType() 
    {
        return templateType;
    }
    public void setTemplateDescription(String templateDescription) 
    {
        this.templateDescription = templateDescription;
    }

    public String getTemplateDescription() 
    {
        return templateDescription;
    }
    public void setPreviewImage(String previewImage) 
    {
        this.previewImage = previewImage;
    }

    public String getPreviewImage() 
    {
        return previewImage;
    }
    public void setTemplateCode(String templateCode) 
    {
        this.templateCode = templateCode;
    }

    public String getTemplateCode() 
    {
        return templateCode;
    }
    public void setCategory(String category) 
    {
        this.category = category;
    }

    public String getCategory() 
    {
        return category;
    }
    public void setTags(String tags) 
    {
        this.tags = tags;
    }

    public String getTags() 
    {
        return tags;
    }
    public void setDownloadCount(Integer downloadCount) 
    {
        this.downloadCount = downloadCount;
    }

    public Integer getDownloadCount() 
    {
        return downloadCount;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setSortOrder(Integer sortOrder) 
    {
        this.sortOrder = sortOrder;
    }

    public Integer getSortOrder() 
    {
        return sortOrder;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("templateId", getTemplateId())
            .append("templateName", getTemplateName())
            .append("templateType", getTemplateType())
            .append("templateDescription", getTemplateDescription())
            .append("previewImage", getPreviewImage())
            .append("templateCode", getTemplateCode())
            .append("category", getCategory())
            .append("tags", getTags())
            .append("downloadCount", getDownloadCount())
            .append("status", getStatus())
            .append("sortOrder", getSortOrder())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
} 