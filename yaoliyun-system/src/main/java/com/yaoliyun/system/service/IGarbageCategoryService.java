package com.yaoliyun.system.service;

import java.util.List;
import com.yaoliyun.system.domain.GarbageCategory;

/**
 * 垃圾分类类别Service接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface IGarbageCategoryService 
{
    /**
     * 查询垃圾分类类别
     * 
     * @param categoryId 垃圾分类类别主键
     * @return 垃圾分类类别
     */
    public GarbageCategory selectGarbageCategoryByCategoryId(Long categoryId);

    /**
     * 查询垃圾分类类别列表
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 垃圾分类类别集合
     */
    public List<GarbageCategory> selectGarbageCategoryList(GarbageCategory garbageCategory);

    /**
     * 新增垃圾分类类别
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 结果
     */
    public int insertGarbageCategory(GarbageCategory garbageCategory);

    /**
     * 修改垃圾分类类别
     * 
     * @param garbageCategory 垃圾分类类别
     * @return 结果
     */
    public int updateGarbageCategory(GarbageCategory garbageCategory);

    /**
     * 批量删除垃圾分类类别
     * 
     * @param categoryIds 需要删除的垃圾分类类别主键集合
     * @return 结果
     */
    public int deleteGarbageCategoryByCategoryIds(Long[] categoryIds);

    /**
     * 删除垃圾分类类别信息
     * 
     * @param categoryId 垃圾分类类别主键
     * @return 结果
     */
    public int deleteGarbageCategoryByCategoryId(Long categoryId);
}
