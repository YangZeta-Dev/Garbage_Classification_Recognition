package com.yaoliyun.system.service;

import java.util.List;
import com.yaoliyun.system.domain.GarbageRecognitionRecord;

/**
 * 垃圾识别记录Service接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface IGarbageRecognitionRecordService 
{
    /**
     * 查询垃圾识别记录
     * 
     * @param recordId 垃圾识别记录主键
     * @return 垃圾识别记录
     */
    public GarbageRecognitionRecord selectGarbageRecognitionRecordByRecordId(Long recordId);

    /**
     * 查询垃圾识别记录列表
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 垃圾识别记录集合
     */
    public List<GarbageRecognitionRecord> selectGarbageRecognitionRecordList(GarbageRecognitionRecord garbageRecognitionRecord);

    /**
     * 新增垃圾识别记录
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 结果
     */
    public int insertGarbageRecognitionRecord(GarbageRecognitionRecord garbageRecognitionRecord);

    /**
     * 修改垃圾识别记录
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 结果
     */
    public int updateGarbageRecognitionRecord(GarbageRecognitionRecord garbageRecognitionRecord);

    /**
     * 批量删除垃圾识别记录
     * 
     * @param recordIds 需要删除的垃圾识别记录主键集合
     * @return 结果
     */
    public int deleteGarbageRecognitionRecordByRecordIds(Long[] recordIds);

    /**
     * 删除垃圾识别记录信息
     * 
     * @param recordId 垃圾识别记录主键
     * @return 结果
     */
    public int deleteGarbageRecognitionRecordByRecordId(Long recordId);

    /**
     * 获取用户ID选项列表
     * 
     * @return 用户ID选项列表
     */
    public List<?> getUserIdOptions();

    /**
     * 获取分类ID选项列表
     * 
     * @return 分类ID选项列表
     */
    public List<?> getCategoryIdOptions();
}
