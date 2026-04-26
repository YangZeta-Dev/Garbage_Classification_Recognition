package com.yaoliyun.system.service.impl;

import java.util.List;
import com.yaoliyun.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.GarbageCategoryMapper;
import com.yaoliyun.system.domain.GarbageCategory;
import com.yaoliyun.system.service.IGarbageCategoryService;

/**
 * 垃圾分类类别Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageCategoryServiceImpl implements IGarbageCategoryService 
{
    @Autowired
    private GarbageCategoryMapper garbageCategoryMapper;

    /**
     * 查询垃圾分类类别
     * 
     * @param categoryId 垃圾分类类别主键
     * @return 垃圾分类类别
     */
    @Override
    public GarbageCategory selectGarbageCategoryByCategoryId(Long categoryId)
    {
        return garbageCategoryMapper.selectGarbageCategoryByCategoryId(categoryId);
    }

    /**
     * 查询垃圾分类类别列表
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 垃圾分类类别
     */
    @Override
    public List<GarbageCategory> selectGarbageCategoryList(GarbageCategory garbageCategory)
    {
        return garbageCategoryMapper.selectGarbageCategoryList(garbageCategory);
    }

    /**
     * 新增垃圾分类类别
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 结果
     */
    @Override
    public int insertGarbageCategory(GarbageCategory garbageCategory)
    {
        garbageCategory.setCreateTime(DateUtils.getNowDate());
        return garbageCategoryMapper.insertGarbageCategory(garbageCategory);
    }

    /**
     * 修改垃圾分类类别
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 结果
     */
    @Override
    public int updateGarbageCategory(GarbageCategory garbageCategory)
    {
        garbageCategory.setUpdateTime(DateUtils.getNowDate());
        return garbageCategoryMapper.updateGarbageCategory(garbageCategory);
    }

    /**
     * 批量删除垃圾分类类别
     * 
     * @param categoryIds 需要删除的垃圾分类类别主键
     * @return 结果
     */
    @Override
    public int deleteGarbageCategoryByCategoryIds(Long[] categoryIds)
    {
        return garbageCategoryMapper.deleteGarbageCategoryByCategoryIds(categoryIds);
    }

    /**
     * 删除垃圾分类类别信息
     * 
     * @param categoryId 垃圾分类类别主键
     * @return 结果
     */
    @Override
    public int deleteGarbageCategoryByCategoryId(Long categoryId)
    {
        return garbageCategoryMapper.deleteGarbageCategoryByCategoryId(categoryId);
    }
}
