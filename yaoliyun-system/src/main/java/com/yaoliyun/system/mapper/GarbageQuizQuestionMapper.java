package com.yaoliyun.system.mapper;

import java.util.List;
import com.yaoliyun.system.domain.GarbageQuizQuestion;

/**
 * 垃圾分类测验题目Mapper接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface GarbageQuizQuestionMapper 
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
     * 删除垃圾分类测验题目
     * 
     * @param questionId 垃圾分类测验题目主键
     * @return 结果
     */
    public int deleteGarbageQuizQuestionByQuestionId(Long questionId);

    /**
     * 批量删除垃圾分类测验题目
     * 
     * @param questionIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGarbageQuizQuestionByQuestionIds(Long[] questionIds);

    /**
     * 查询关联文章ID选项列表
     * 
     * @return 关联文章ID选项列表
     */
    public List<?> selectArticleIdOptions();

    /**
     * 查询关联分类ID选项列表
     * 
     * @return 关联分类ID选项列表
     */
    public List<?> selectCategoryIdOptions();
}
