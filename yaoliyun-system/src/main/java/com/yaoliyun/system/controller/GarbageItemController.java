package com.yaoliyun.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.annotation.Log;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.enums.BusinessType;
import com.yaoliyun.system.domain.GarbageItem;
import com.yaoliyun.system.service.IGarbageItemService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;

/**
 * 垃圾物品Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/item")
public class GarbageItemController extends BaseController
{
    @Autowired
    private IGarbageItemService garbageItemService;

    /**
     * 查询垃圾物品列表
     */
    @PreAuthorize("@ss.hasPermi('system:item:list')")
    @GetMapping("/list")
    public TableDataInfo list(GarbageItem garbageItem)
    {
        startPage();
        List<GarbageItem> list = garbageItemService.selectGarbageItemList(garbageItem);
        return getDataTable(list);
    }

    /**
     * 导出垃圾物品列表
     */
    @PreAuthorize("@ss.hasPermi('system:item:export')")
    @Log(title = "垃圾物品", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GarbageItem garbageItem)
    {
        List<GarbageItem> list = garbageItemService.selectGarbageItemList(garbageItem);
        ExcelUtil<GarbageItem> util = new ExcelUtil<GarbageItem>(GarbageItem.class);
        util.exportExcel(response, list, "垃圾物品数据");
    }

    /**
     * 获取垃圾物品详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:item:query')")
    @GetMapping(value = "/{itemId}")
    public AjaxResult getInfo(@PathVariable("itemId") Long itemId)
    {
        return success(garbageItemService.selectGarbageItemByItemId(itemId));
    }

    /**
     * 新增垃圾物品
     */
    @PreAuthorize("@ss.hasPermi('system:item:add')")
    @Log(title = "垃圾物品", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GarbageItem garbageItem)
    {
        return toAjax(garbageItemService.insertGarbageItem(garbageItem));
    }

    /**
     * 修改垃圾物品
     */
    @PreAuthorize("@ss.hasPermi('system:item:edit')")
    @Log(title = "垃圾物品", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GarbageItem garbageItem)
    {
        return toAjax(garbageItemService.updateGarbageItem(garbageItem));
    }

    /**
     * 删除垃圾物品
     */
    @PreAuthorize("@ss.hasPermi('system:item:remove')")
    @Log(title = "垃圾物品", businessType = BusinessType.DELETE)
	@DeleteMapping("/{itemIds}")
    public AjaxResult remove(@PathVariable Long[] itemIds)
    {
        return toAjax(garbageItemService.deleteGarbageItemByItemIds(itemIds));
    }

    /**
     * 获取所属类别ID（关联垃圾分类类别表）选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:item:query')")
    @GetMapping("/categoryId/options")
    public AjaxResult getCategoryIdOptions()
    {
        return success(garbageItemService.getCategoryIdOptions());
    }
}
