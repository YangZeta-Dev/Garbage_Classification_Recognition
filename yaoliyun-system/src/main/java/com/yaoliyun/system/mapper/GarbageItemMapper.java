package com.yaoliyun.system.mapper;

import java.util.List;
import com.yaoliyun.system.domain.GarbageItem;

/**
 * 垃圾物品Mapper接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface GarbageItemMapper 
{
    /**
     * 查询垃圾物品
     * 
     * @param itemId 垃圾物品主键
     * @return 垃圾物品
     */
    public GarbageItem selectGarbageItemByItemId(Long itemId);

    /**
     * 查询垃圾物品列表
     * 
     * @param garbageItem 垃圾物品
     * @return 垃圾物品集合
     */
    public List<GarbageItem> selectGarbageItemList(GarbageItem garbageItem);

    /**
     * 新增垃圾物品
     * 
     * @param garbageItem 垃圾物品
     * @return 结果
     */
    public int insertGarbageItem(GarbageItem garbageItem);

    /**
     * 修改垃圾物品
     * 
     * @param garbageItem 垃圾物品
     * @return 结果
     */
    public int updateGarbageItem(GarbageItem garbageItem);

    /**
     * 删除垃圾物品
     * 
     * @param itemId 垃圾物品主键
     * @return 结果
     */
    public int deleteGarbageItemByItemId(Long itemId);

    /**
     * 批量删除垃圾物品
     * 
     * @param itemIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGarbageItemByItemIds(Long[] itemIds);

    /**
     * 查询所属类别ID（关联垃圾分类类别表）选项列表
     * 
     * @return 所属类别ID（关联垃圾分类类别表）选项列表
     */
    public List<?> selectCategoryIdOptions();
}
