package com.yaoliyun.system.service.impl;

import java.util.List;
import com.yaoliyun.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.GarbageItemMapper;
import com.yaoliyun.system.domain.GarbageItem;
import com.yaoliyun.system.service.IGarbageItemService;

/**
 * 垃圾物品Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageItemServiceImpl implements IGarbageItemService 
{
    @Autowired
    private GarbageItemMapper garbageItemMapper;

    /**
     * 查询垃圾物品
     * 
     * @param itemId 垃圾物品主键
     * @return 垃圾物品
     */
    @Override
    public GarbageItem selectGarbageItemByItemId(Long itemId)
    {
        return garbageItemMapper.selectGarbageItemByItemId(itemId);
    }

    /**
     * 查询垃圾物品列表
     * 
     * @param garbageItem 垃圾物品
     * @return 垃圾物品
     */
    @Override
    public List<GarbageItem> selectGarbageItemList(GarbageItem garbageItem)
    {
        return garbageItemMapper.selectGarbageItemList(garbageItem);
    }

    /**
     * 新增垃圾物品
     * 
     * @param garbageItem 垃圾物品
     * @return 结果
     */
    @Override
    public int insertGarbageItem(GarbageItem garbageItem)
    {
        garbageItem.setCreateTime(DateUtils.getNowDate());
        return garbageItemMapper.insertGarbageItem(garbageItem);
    }

    /**
     * 修改垃圾物品
     * 
     * @param garbageItem 垃圾物品
     * @return 结果
     */
    @Override
    public int updateGarbageItem(GarbageItem garbageItem)
    {
        garbageItem.setUpdateTime(DateUtils.getNowDate());
        return garbageItemMapper.updateGarbageItem(garbageItem);
    }

    /**
     * 批量删除垃圾物品
     * 
     * @param itemIds 需要删除的垃圾物品主键
     * @return 结果
     */
    @Override
    public int deleteGarbageItemByItemIds(Long[] itemIds)
    {
        return garbageItemMapper.deleteGarbageItemByItemIds(itemIds);
    }

    /**
     * 删除垃圾物品信息
     * 
     * @param itemId 垃圾物品主键
     * @return 结果
     */
    @Override
    public int deleteGarbageItemByItemId(Long itemId)
    {
        return garbageItemMapper.deleteGarbageItemByItemId(itemId);
    }

    /**
     * 获取所属类别ID（关联垃圾分类类别表）选项列表
     * 
     * @return 所属类别ID（关联垃圾分类类别表）选项列表
     */
    @Override
    public List<?> getCategoryIdOptions()
    {
        // 查询关联表数据
        return garbageItemMapper.selectCategoryIdOptions();
    }
}
