package com.yaoliyun.system.service.impl;

import java.util.List;
import com.yaoliyun.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.GarbageRecognitionRecordMapper;
import com.yaoliyun.system.domain.GarbageRecognitionRecord;
import com.yaoliyun.system.service.IGarbageRecognitionRecordService;

/**
 * 垃圾识别记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageRecognitionRecordServiceImpl implements IGarbageRecognitionRecordService 
{
    @Autowired
    private GarbageRecognitionRecordMapper garbageRecognitionRecordMapper;

    /**
     * 查询垃圾识别记录
     * 
     * @param recordId 垃圾识别记录主键
     * @return 垃圾识别记录
     */
    @Override
    public GarbageRecognitionRecord selectGarbageRecognitionRecordByRecordId(Long recordId)
    {
        return garbageRecognitionRecordMapper.selectGarbageRecognitionRecordByRecordId(recordId);
    }

    /**
     * 查询垃圾识别记录列表
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 垃圾识别记录
     */
    @Override
    public List<GarbageRecognitionRecord> selectGarbageRecognitionRecordList(GarbageRecognitionRecord garbageRecognitionRecord)
    {
        return garbageRecognitionRecordMapper.selectGarbageRecognitionRecordList(garbageRecognitionRecord);
    }

    /**
     * 新增垃圾识别记录
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 结果
     */
    @Override
    public int insertGarbageRecognitionRecord(GarbageRecognitionRecord garbageRecognitionRecord)
    {
        garbageRecognitionRecord.setCreateTime(DateUtils.getNowDate());
        return garbageRecognitionRecordMapper.insertGarbageRecognitionRecord(garbageRecognitionRecord);
    }

    /**
     * 修改垃圾识别记录
     * 
     * @param garbageRecognitionRecord 垃圾识别记录
     * @return 结果
     */
    @Override
    public int updateGarbageRecognitionRecord(GarbageRecognitionRecord garbageRecognitionRecord)
    {
        return garbageRecognitionRecordMapper.updateGarbageRecognitionRecord(garbageRecognitionRecord);
    }

    /**
     * 批量删除垃圾识别记录
     * 
     * @param recordIds 需要删除的垃圾识别记录主键
     * @return 结果
     */
    @Override
    public int deleteGarbageRecognitionRecordByRecordIds(Long[] recordIds)
    {
        return garbageRecognitionRecordMapper.deleteGarbageRecognitionRecordByRecordIds(recordIds);
    }

    /**
     * 删除垃圾识别记录信息
     * 
     * @param recordId 垃圾识别记录主键
     * @return 结果
     */
    @Override
    public int deleteGarbageRecognitionRecordByRecordId(Long recordId)
    {
        return garbageRecognitionRecordMapper.deleteGarbageRecognitionRecordByRecordId(recordId);
    }

    /**
     * 获取用户ID选项列表
     * 
     * @return 用户ID选项列表
     */
    @Override
    public List<?> getUserIdOptions()
    {
        // 查询关联表数据
        return garbageRecognitionRecordMapper.selectUserIdOptions();
    }

    /**
     * 获取分类ID选项列表
     * 
     * @return 分类ID选项列表
     */
    @Override
    public List<?> getCategoryIdOptions()
    {
        // 查询关联表数据
        return garbageRecognitionRecordMapper.selectCategoryIdOptions();
    }
}
