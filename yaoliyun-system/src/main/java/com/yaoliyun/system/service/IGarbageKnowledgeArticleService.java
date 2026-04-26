package com.yaoliyun.system.service;

import java.util.List;
import com.yaoliyun.system.domain.GarbageKnowledgeArticle;

/**
 * 垃圾分类知识文章Service接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface IGarbageKnowledgeArticleService 
{
    /**
     * 查询垃圾分类知识文章
     * 
     * @param articleId 垃圾分类知识文章主键
     * @return 垃圾分类知识文章
     */
    public GarbageKnowledgeArticle selectGarbageKnowledgeArticleByArticleId(Long articleId);

    /**
     * 查询垃圾分类知识文章列表
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 垃圾分类知识文章集合
     */
    public List<GarbageKnowledgeArticle> selectGarbageKnowledgeArticleList(GarbageKnowledgeArticle garbageKnowledgeArticle);

    /**
     * 新增垃圾分类知识文章
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 结果
     */
    public int insertGarbageKnowledgeArticle(GarbageKnowledgeArticle garbageKnowledgeArticle);

    /**
     * 修改垃圾分类知识文章
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 结果
     */
    public int updateGarbageKnowledgeArticle(GarbageKnowledgeArticle garbageKnowledgeArticle);

    /**
     * 批量删除垃圾分类知识文章
     * 
     * @param articleIds 需要删除的垃圾分类知识文章主键集合
     * @return 结果
     */
    public int deleteGarbageKnowledgeArticleByArticleIds(Long[] articleIds);

    /**
     * 删除垃圾分类知识文章信息
     * 
     * @param articleId 垃圾分类知识文章主键
     * @return 结果
     */
    public int deleteGarbageKnowledgeArticleByArticleId(Long articleId);

    /**
     * 获取关联分类ID选项列表
     * 
     * @return 关联分类ID选项列表
     */
    public List<?> getCategoryIdOptions();

    /**
     * 增加文章浏览量
     * 
     * @param articleId 文章ID
     * @return 结果
     */
    public int incrementViewCount(Long articleId);
}
