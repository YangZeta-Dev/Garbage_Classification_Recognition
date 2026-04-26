package com.yaoliyun.system.service.impl;

import java.util.List;
import com.yaoliyun.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.GarbageKnowledgeArticleMapper;
import com.yaoliyun.system.domain.GarbageKnowledgeArticle;
import com.yaoliyun.system.service.IGarbageKnowledgeArticleService;

/**
 * 垃圾分类知识文章Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageKnowledgeArticleServiceImpl implements IGarbageKnowledgeArticleService 
{
    @Autowired
    private GarbageKnowledgeArticleMapper garbageKnowledgeArticleMapper;

    /**
     * 查询垃圾分类知识文章
     * 
     * @param articleId 垃圾分类知识文章主键
     * @return 垃圾分类知识文章
     */
    @Override
    public GarbageKnowledgeArticle selectGarbageKnowledgeArticleByArticleId(Long articleId)
    {
        return garbageKnowledgeArticleMapper.selectGarbageKnowledgeArticleByArticleId(articleId);
    }

    /**
     * 查询垃圾分类知识文章列表
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 垃圾分类知识文章
     */
    @Override
    public List<GarbageKnowledgeArticle> selectGarbageKnowledgeArticleList(GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        return garbageKnowledgeArticleMapper.selectGarbageKnowledgeArticleList(garbageKnowledgeArticle);
    }

    /**
     * 新增垃圾分类知识文章
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 结果
     */
    @Override
    public int insertGarbageKnowledgeArticle(GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        garbageKnowledgeArticle.setCreateTime(DateUtils.getNowDate());
        return garbageKnowledgeArticleMapper.insertGarbageKnowledgeArticle(garbageKnowledgeArticle);
    }

    /**
     * 修改垃圾分类知识文章
     * 
     * @param garbageKnowledgeArticle 垃圾分类知识文章
     * @return 结果
     */
    @Override
    public int updateGarbageKnowledgeArticle(GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        garbageKnowledgeArticle.setUpdateTime(DateUtils.getNowDate());
        return garbageKnowledgeArticleMapper.updateGarbageKnowledgeArticle(garbageKnowledgeArticle);
    }

    /**
     * 批量删除垃圾分类知识文章
     * 
     * @param articleIds 需要删除的垃圾分类知识文章主键
     * @return 结果
     */
    @Override
    public int deleteGarbageKnowledgeArticleByArticleIds(Long[] articleIds)
    {
        return garbageKnowledgeArticleMapper.deleteGarbageKnowledgeArticleByArticleIds(articleIds);
    }

    /**
     * 删除垃圾分类知识文章信息
     * 
     * @param articleId 垃圾分类知识文章主键
     * @return 结果
     */
    @Override
    public int deleteGarbageKnowledgeArticleByArticleId(Long articleId)
    {
        return garbageKnowledgeArticleMapper.deleteGarbageKnowledgeArticleByArticleId(articleId);
    }

    /**
     * 获取关联分类ID选项列表
     * 
     * @return 关联分类ID选项列表
     */
    @Override
    public List<?> getCategoryIdOptions()
    {
        // 查询关联表数据
        return garbageKnowledgeArticleMapper.selectCategoryIdOptions();
    }

    /**
     * 增加文章浏览量
     * 
     * @param articleId 文章ID
     * @return 结果
     */
    @Override
    public int incrementViewCount(Long articleId)
    {
        return garbageKnowledgeArticleMapper.incrementViewCount(articleId);
    }
}
