package xxung.todo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import xxung.common.dao.AbstractDAO;

@Repository("todoDAO")
public class TodoDAO extends AbstractDAO {

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getTodoList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) selectList("todo.getTodoList", param);
	}

	public int getPaging() {
		// TODO Auto-generated method stub
		return (Integer) selectOne("todo.getPaging");
	}

	public String saveTodoListContents(Map<String, Object> param) {
		// TODO Auto-generated method stub
		insert("todo.saveTodoListContents", param);
		String key = (String) param.get("list_key");
		return key;
	}

	public void saveTodoListPriority(Map<String, Object> param) {
		// TODO Auto-generated method stub
		insert("todo.saveTodoListPriority", param);
	}

	public void saveTodoListStatus(Map<String, Object> param) {
		// TODO Auto-generated method stub
		insert("todo.saveTodoListStatus", param);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getTodoDetail(String list_key) {
		// TODO Auto-generated method stub
		return (Map<String, Object>) selectOne("todo.getTodoDetail", list_key);
	}

	public void completeTodo(String list_key) {
		// TODO Auto-generated method stub
		update("todo.completeTodo", list_key);
	}

	public void removePriority(String list_key) {
		// TODO Auto-generated method stub
		update("todo.removePriority", list_key);
	}

	public void deleteTodo(String list_key) {
		// TODO Auto-generated method stub
		delete("todo.deleteTodoPriority", list_key);
		delete("todo.deleteTodoStatus", list_key);
		delete("todo.deleteTodoContents", list_key);
	}

	public void editTodoListContents(Map<String, Object> param) {
		// TODO Auto-generated method stub
		update("todo.editTodoListContents", param);
	}

	public void editTodoListPriority(Map<String, Object> param) {
		// TODO Auto-generated method stub
		update("todo.editTodoListPriority", param);
	}

	public void editTodoListStatus(Map<String, Object> param) {
		// TODO Auto-generated method stub
		update("todo.editTodoListStatus", param);
	}

	public void addPriority(Map<String, Object> param) {
		// TODO Auto-generated method stub
		update("todo.addPriority", param);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPriorityList(int num) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) selectList("todo.getPriorityList", num);
	}

	public void updatePriority(List<Map<String, Object>> list) {
		// TODO Auto-generated method stub
		update("todo.updatePriority", list);
	}

	public int getMaxPriority() {
		// TODO Auto-generated method stub
		return (int) selectOne("todo.getMaxPriority");
	}
}