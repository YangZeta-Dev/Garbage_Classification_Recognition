package com.yaoliyun.system.service.impl;

import java.util.List;
import com.yaoliyun.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.GarbageQuizQuestionMapper;
import com.yaoliyun.system.domain.GarbageQuizQuestion;
import com.yaoliyun.system.service.IGarbageQuizQuestionService;

/**
 * 垃圾分类测验题目Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageQuizQuestionServiceImpl implements IGarbageQuizQuestionService 
{
    @Autowired
    private GarbageQuizQuestionMapper garbageQuizQuestionMapper;

    /**
     * 查询垃圾分类测验题目
     * 
     * @param questionId 垃圾分类测验题目主键
     * @return 垃圾分类测验题目
     */
    @Override
    public GarbageQuizQuestion selectGarbageQuizQuestionByQuestionId(Long questionId)
    {
        return garbageQuizQuestionMapper.selectGarbageQuizQuestionByQuestionId(questionId);
    }

    /**
     * 查询垃圾分类测验题目列表
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 垃圾分类测验题目
     */
    @Override
    public List<GarbageQuizQuestion> selectGarbageQuizQuestionList(GarbageQuizQuestion garbageQuizQuestion)
    {
        return garbageQuizQuestionMapper.selectGarbageQuizQuestionList(garbageQuizQuestion);
    }

    /**
     * 新增垃圾分类测验题目
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 结果
     */
    @Override
    public int insertGarbageQuizQuestion(GarbageQuizQuestion garbageQuizQuestion)
    {
        garbageQuizQuestion.setCreateTime(DateUtils.getNowDate());
        return garbageQuizQuestionMapper.insertGarbageQuizQuestion(garbageQuizQuestion);
    }

    /**
     * 修改垃圾分类测验题目
     * 
     * @param garbageQuizQuestion 垃圾分类测验题目
     * @return 结果
     */
    @Override
    public int updateGarbageQuizQuestion(GarbageQuizQuestion garbageQuizQuestion)
    {
        garbageQuizQuestion.setUpdateTime(DateUtils.getNowDate());
        return garbageQuizQuestionMapper.updateGarbageQuizQuestion(garbageQuizQuestion);
    }

    /**
     * 批量删除垃圾分类测验题目
     * 
     * @param questionIds 需要删除的垃圾分类测验题目主键
     * @return 结果
     */
    @Override
    public int deleteGarbageQuizQuestionByQuestionIds(Long[] questionIds)
    {
        return garbageQuizQuestionMapper.deleteGarbageQuizQuestionByQuestionIds(questionIds);
    }

    /**
     * 删除垃圾分类测验题目信息
     * 
     * @param questionId 垃圾分类测验题目主键
     * @return 结果
     */
    @Override
    public int deleteGarbageQuizQuestionByQuestionId(Long questionId)
    {
        return garbageQuizQuestionMapper.deleteGarbageQuizQuestionByQuestionId(questionId);
    }

    /**
     * 获取关联文章ID选项列表
     * 
     * @return 关联文章ID选项列表
     */
    @Override
    public List<?> getArticleIdOptions()
    {
        // 查询关联表数据
        return garbageQuizQuestionMapper.selectArticleIdOptions();
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
        return garbageQuizQuestionMapper.selectCategoryIdOptions();
    }
}
