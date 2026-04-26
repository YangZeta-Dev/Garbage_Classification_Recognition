package com.yaoliyun.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;

/**
 * 垃圾分类测验题目对象 garbage_quiz_question
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageQuizQuestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 题目ID */
    private Long questionId;

    /** 关联文章ID */
    @Excel(name = "关联文章ID")
    private Long articleId;

    /** 关联文章ID关联字段（关联garbage_knowledge_article表） */
    private String title;

    /** 关联分类ID */
    @Excel(name = "关联分类ID")
    private Long categoryId;

    /** 关联分类ID关联字段（关联garbage_category表） */
    private String categoryName;

    /** 题目内容 */
    @Excel(name = "题目内容")
    private String questionContent;

    /** 选项A */
    @Excel(name = "选项A")
    private String optionA;

    /** 选项B */
    @Excel(name = "选项B")
    private String optionB;

    /** 选项C */
    @Excel(name = "选项C")
    private String optionC;

    /** 选项D */
    @Excel(name = "选项D")
    private String optionD;

    /** 正确答案（A/B/C/D） */
    @Excel(name = "正确答案", readConverterExp = "A=/B/C/D")
    private String correctAnswer;

    /** 答案解析 */
    @Excel(name = "答案解析")
    private String explanation;

    /** 题目分值 */
    @Excel(name = "题目分值")
    private Long pointsValue;

    /** 难度等级（1简单 2中等 3困难） */
    @Excel(name = "难度等级", readConverterExp = "1=简单,2=中等,3=困难")
    private Long difficulty;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public void setQuestionId(Long questionId) 
    {
        this.questionId = questionId;
    }

    public Long getQuestionId() 
    {
        return questionId;
    }

    public void setArticleId(Long articleId) 
    {
        this.articleId = articleId;
    }

    public Long getArticleId() 
    {
        return articleId;
    }

    public void setTitle(String title) 
    {
        this.title = title;
    }

    public String getTitle() 
    {
        return title;
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

    public void setQuestionContent(String questionContent) 
    {
        this.questionContent = questionContent;
    }

    public String getQuestionContent() 
    {
        return questionContent;
    }

    public void setOptionA(String optionA) 
    {
        this.optionA = optionA;
    }

    public String getOptionA() 
    {
        return optionA;
    }

    public void setOptionB(String optionB) 
    {
        this.optionB = optionB;
    }

    public String getOptionB() 
    {
        return optionB;
    }

    public void setOptionC(String optionC) 
    {
        this.optionC = optionC;
    }

    public String getOptionC() 
    {
        return optionC;
    }

    public void setOptionD(String optionD) 
    {
        this.optionD = optionD;
    }

    public String getOptionD() 
    {
        return optionD;
    }

    public void setCorrectAnswer(String correctAnswer) 
    {
        this.correctAnswer = correctAnswer;
    }

    public String getCorrectAnswer() 
    {
        return correctAnswer;
    }

    public void setExplanation(String explanation) 
    {
        this.explanation = explanation;
    }

    public String getExplanation() 
    {
        return explanation;
    }

    public void setPointsValue(Long pointsValue) 
    {
        this.pointsValue = pointsValue;
    }

    public Long getPointsValue() 
    {
        return pointsValue;
    }

    public void setDifficulty(Long difficulty) 
    {
        this.difficulty = difficulty;
    }

    public Long getDifficulty() 
    {
        return difficulty;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("questionId", getQuestionId())
            .append("articleId", getArticleId())
            .append("categoryId", getCategoryId())
            .append("questionContent", getQuestionContent())
            .append("optionA", getOptionA())
            .append("optionB", getOptionB())
            .append("optionC", getOptionC())
            .append("optionD", getOptionD())
            .append("correctAnswer", getCorrectAnswer())
            .append("explanation", getExplanation())
            .append("pointsValue", getPointsValue())
            .append("difficulty", getDifficulty())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
