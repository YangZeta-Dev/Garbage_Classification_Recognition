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
import com.yaoliyun.system.domain.GarbageRecognitionRecord;
import com.yaoliyun.system.service.IGarbageRecognitionRecordService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;

/**
 * 垃圾识别记录Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/record")
public class GarbageRecognitionRecordController extends BaseController
{
    @Autowired
    private IGarbageRecognitionRecordService garbageRecognitionRecordService;

    /**
     * 查询垃圾识别记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:record:list')")
    @GetMapping("/list")
    public TableDataInfo list(GarbageRecognitionRecord garbageRecognitionRecord)
    {
        startPage();
        List<GarbageRecognitionRecord> list = garbageRecognitionRecordService.selectGarbageRecognitionRecordList(garbageRecognitionRecord);
        return getDataTable(list);
    }

    /**
     * 导出垃圾识别记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:record:export')")
    @Log(title = "垃圾识别记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GarbageRecognitionRecord garbageRecognitionRecord)
    {
        List<GarbageRecognitionRecord> list = garbageRecognitionRecordService.selectGarbageRecognitionRecordList(garbageRecognitionRecord);
        ExcelUtil<GarbageRecognitionRecord> util = new ExcelUtil<GarbageRecognitionRecord>(GarbageRecognitionRecord.class);
        util.exportExcel(response, list, "垃圾识别记录数据");
    }

    /**
     * 获取垃圾识别记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:record:query')")
    @GetMapping(value = "/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId)
    {
        return success(garbageRecognitionRecordService.selectGarbageRecognitionRecordByRecordId(recordId));
    }

    /**
     * 新增垃圾识别记录
     */
    @PreAuthorize("@ss.hasPermi('system:record:add')")
    @Log(title = "垃圾识别记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GarbageRecognitionRecord garbageRecognitionRecord)
    {
        return toAjax(garbageRecognitionRecordService.insertGarbageRecognitionRecord(garbageRecognitionRecord));
    }

    /**
     * 修改垃圾识别记录
     */
    @PreAuthorize("@ss.hasPermi('system:record:edit')")
    @Log(title = "垃圾识别记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GarbageRecognitionRecord garbageRecognitionRecord)
    {
        return toAjax(garbageRecognitionRecordService.updateGarbageRecognitionRecord(garbageRecognitionRecord));
    }

    /**
     * 删除垃圾识别记录
     */
    @PreAuthorize("@ss.hasPermi('system:record:remove')")
    @Log(title = "垃圾识别记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds)
    {
        return toAjax(garbageRecognitionRecordService.deleteGarbageRecognitionRecordByRecordIds(recordIds));
    }

    /**
     * 获取用户ID选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:record:query')")
    @GetMapping("/userId/options")
    public AjaxResult getUserIdOptions()
    {
        return success(garbageRecognitionRecordService.getUserIdOptions());
    }

    /**
     * 获取分类ID选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:record:query')")
    @GetMapping("/categoryId/options")
    public AjaxResult getCategoryIdOptions()
    {
        return success(garbageRecognitionRecordService.getCategoryIdOptions());
    }
}
