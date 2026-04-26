package com.yaoliyun.system.service;

import java.util.List;
import com.yaoliyun.system.domain.GarbageQuizQuestion;

/**
 * 垃圾分类测验题目Service接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface IGarbageQuizQuestionService 
{
    /**
     * 查询垃圾分类测验题目
     * 
     * @param questionId 垃圾分类测验题目主键
     * @return 垃圾分类测验题目
     */
    public GarbageQuizQuestion selectGarbageQuizQuestionByQuestionId(Long questionId);

    /**
     * 查询垃圾分类测验题目列表
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 垃圾分类测验题目集合
     */
    public List<GarbageQuizQuestion> selectGarbageQuizQuestionList(GarbageQuizQuestion garbageQuizQuestion);

    /**
     * 新增垃圾分类测验题目
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 结果
     */
    public int insertGarbageQuizQuestion(GarbageQuizQuestion garbageQuizQuestion);

    /**
     * 修改垃圾分类测验题目
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 结果
     */
    public int updateGarbageQuizQuestion(GarbageQuizQuestion garbageQuizQuestion);

    /**
     * 批量删除垃圾分类测验题目
     * 
     * @param questionIds 需要删除的垃圾分类测验题目主键集合
     * @return 结果
     */
    public int deleteGarbageQuizQuestionByQuestionIds(Long[] questionIds);

    /**
     * 删除垃圾分类测验题目信息
     * 
     * @param questionId 垃圾分类测验题目主键
     * @return 结果
     */
    public int deleteGarbageQuizQuestionByQuestionId(Long questionId);

    /**
     * 获取关联文章ID选项列表
     * 
     * @return 关联文章ID选项列表
     */
    public List<?> getArticleIdOptions();

    /**
     * 获取关联分类ID选项列表
     * 
     * @return 关联分类ID选项列表
     */
    public List<?> getCategoryIdOptions();
}
